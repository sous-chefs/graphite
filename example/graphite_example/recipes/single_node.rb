apt_update 'update' if platform_family?('debian')
include_recipe 'runit'
include_recipe 'graphite::carbon'
include_recipe 'graphite::_web_packages'

storage_dir = node['graphite']['storage_dir']

graphite_carbon_cache 'default' do
  config ({
    enable_logrotation: true,
    user: 'graphite',
    max_cache_size: 'inf',
    max_updates_per_second: 500,
    max_creates_per_minute: 50,
    line_receiver_interface: '0.0.0.0',
    line_receiver_port: 2003,
    udp_receiver_port: 2003,
    pickle_receiver_port: 2004,
    enable_udp_listener: true,
    cache_query_port: '7002',
    cache_write_strategy: 'sorted',
    use_flow_control: true,
    log_updates: false,
    log_cache_hits: false,
    whisper_autoflush: false,
    local_data_dir: "#{storage_dir}/whisper/",
  })
end

graphite_storage_schema 'carbon' do
  config ({
    pattern: '^carbon.',
    retentions: '60:90d',
  })
end

graphite_storage_schema 'default_1min_for_1day' do
  config ({
    pattern: '.*',
    retentions: '60s:1d',
  })
end

graphite_service 'cache'

base_dir = (node['graphite']['base_dir']).to_s

graphite_web_config "#{base_dir}/webapp/graphite/local_settings.py" do
  config(secret_key: 'a_very_secret_key_jeah!',
         time_zone: 'America/Chicago',
         conf_dir: "#{base_dir}/conf",
         storage_dir: storage_dir,
         databases: {
           default: {
             # keys need to be upcase here
             NAME: "#{storage_dir}/graphite.db",
             ENGINE: 'django.db.backends.sqlite3',
             USER: nil,
             PASSWORD: nil,
             HOST: nil,
             PORT: nil,
           },
         })
  notifies :restart, 'service[graphite-web]', :delayed
end

directory "#{storage_dir}/log/webapp" do
  owner node['graphite']['user']
  group node['graphite']['group']
  recursive true
end

execute 'python manage.py syncdb --noinput' do
  user node['graphite']['user']
  group node['graphite']['group']
  cwd "#{base_dir}/webapp/graphite"
  creates "#{storage_dir}/graphite.db"
  notifies :run, 'python[set admin password]'
end

# creates an initial user, doesn't require the set_admin_password
# script. But srsly, how ugly is this? could be
# crazy and wrap this as a graphite_user resource with a few
# improvements...
python 'set admin password' do
  action :nothing
  cwd "#{base_dir}/webapp/graphite"
  user node['graphite']['user']
  code <<-PYTHON
import os,sys
sys.path.append("#{base_dir}/webapp/graphite")
os.environ['DJANGO_SETTINGS_MODULE'] = 'settings'
from django.contrib.auth.models import User

username = "#{node['graphite']['user']}"
password = "#{node['graphite']['password']}"

try:
    u = User.objects.create_user(username, password=password)
    u.save()
except Exception,err:
    print "could not create %s" % username
    print "died with error: %s" % str(err)
  PYTHON
end

include_recipe 'graphite::uwsgi'
