include_recipe "apache2::mod_python"

basedir = node['graphite']['base_dir']
storagedir = node['graphite']['storage_dir']
logdir = node['graphite']['log_dir']
timezone = node['graphite']['time_zone']
version = node['graphite']['version']
pyver = node['graphite']['python_version']

package "python-cairo-dev"
package "python-django"
package "python-django-tagging"
package "python-memcache"
package "python-rrdtool"

remote_file "/usr/src/graphite-web-#{version}.tar.gz" do
  source node['graphite']['graphite_web']['uri']
  checksum node['graphite']['graphite_web']['checksum']
end

execute "untar graphite-web" do
  command "tar xzf graphite-web-#{version}.tar.gz"
  creates "/usr/src/graphite-web-#{version}"
  cwd "/usr/src"
end

execute "install graphite-web" do
  command "python setup.py install --prefix #{node['graphite']['base_dir']} --install-lib #{node['graphite']['doc_root']}"
  creates "#{node['graphite']['doc_root']}/graphite_web-#{version}-py#{pyver}.egg-info"
  cwd "/usr/src/graphite-web-#{version}"
end

template "/etc/apache2/sites-available/graphite" do
  source "graphite-vhost.conf.erb"
end

apache_site "000-default" do
  enable false
end

apache_site "graphite"

directory storagedir do
  owner node['apache']['user']
  group node['apache']['group']
end

directory logdir do
  owner node['apache']['user']
  group node['apache']['group']
end

%w{ webapp whisper }.each do |dir|
  directory "#{logdir}/#{dir}" do
    owner node['apache']['user']
    group node['apache']['group']
  end
end

template "#{basedir}/bin/set_admin_passwd.py" do
  source "set_admin_passwd.py.erb"
  mode 00755
end

template "#{node['graphite']['doc_root']}/graphite/local_settings.py" do
  owner node['apache']['user']
  group node['apache']['group']
  variables( :base_dir => basedir,
             :storage_dir => storagedir,
             :log_dir => logdir,
             :time_zone => timezone )
  notifies :restart, "service[apache2]"
end

cookbook_file "#{storagedir}/graphite.db" do
  action :create_if_missing
  notifies :run, "execute[set admin password]"
end

execute "set admin password" do
  command "#{basedir}/bin/set_admin_passwd.py root #{node['graphite']['password']}"
  action :nothing
  only_if { node['graphite']['set_admin_password'] }
end

file "#{storagedir}/graphite.db" do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00644
end

# set basic authentication if desired
htpasswd "#{node['graphite']['basic_authentication']['htpasswd_location']}" do
  user node['graphite']['basic_authentication']['user']
  password node['graphite']['basic_authentication']['password']
  only_if { node['graphite']['basic_authentication']['enabled'] }
end
