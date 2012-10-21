include_recipe "apache2::mod_python"

basedir = node['graphite']['base_dir']
version = node['graphite']['version']
pyver = node['graphite']['python_version']

if Chef::Config[:solo]
  Chef::Log.warn "This recipe uses encrypted data bags. Chef Solo does not support this."
else
  if data_bag_name = node['graphite']['encrypted_data_bag']['name']
    password = Chef::EncryptedDataBagItem.load(data_bag_name, "password")
  else
    password = node['graphite']['password']
  end
end

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
  command "python setup.py install"
  creates "#{node['graphite']['doc_root']}/graphite_web-#{version}-py#{pyver}.egg-info"
  cwd "/usr/src/graphite-web-#{version}"
end

template "/etc/apache2/sites-available/graphite" do
  source "graphite-vhost.conf.erb"
end

apache_site "graphite"

directory "#{basedir}/storage" do
  owner node['apache']['user']
  group node['apache']['group']
end

directory "#{basedir}/storage/log" do
  owner node['apache']['user']
  group node['apache']['group']
end

%w{ webapp whisper }.each do |dir|
  directory "#{basedir}/storage/log/#{dir}" do
    owner node['apache']['user']
    group node['apache']['group']
  end
end

template "#{basedir}/bin/set_admin_passwd.py" do
  source "set_admin_passwd.py.erb"
  mode 00755
end

cookbook_file "#{basedir}/storage/graphite.db" do
  action :create_if_missing
  notifies :run, "execute[set admin password]"
end

execute "set admin password" do
  command "#{basedir}/bin/set_admin_passwd.py root #{password}"
  action :nothing
end

file "#{basedir}/storage/graphite.db" do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00644
end
