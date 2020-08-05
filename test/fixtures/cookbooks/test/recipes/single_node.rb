apt_update 'update' if platform_family?('debian')

node.default['graphite']['twisted_version'] = '19.10.0'
node.default['graphite']['django_version'] = '3.0.9'

include_recipe 'graphite::carbon'
include_recipe 'graphite::web'

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

graphite_web_config "#{base_dir}/lib/python3.8/site-packages/graphite/local_settings.py" do
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

pyenv_script 'django migrate' do
  code "#{node['graphite']['base_dir']}/bin/python #{node['graphite']['base_dir']}/bin/django-admin.py migrate --run-syncdb --settings=\"graphite.settings\" --pythonpath=#{node['graphite']['base_dir']}/webapp"
  user node['graphite']['user']
end

include_recipe 'graphite::uwsgi'
