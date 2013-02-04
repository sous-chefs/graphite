#
# Cookbook Name:: graphite
# Recipe:: web
#
# Copyright 2011, Heavy Water Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "apache2::mod_python"

basedir = node['graphite']['base_dir']
docroot = node['graphite']['doc_root']
storagedir = node['graphite']['storage_dir']
version = node['graphite']['version']
pyver = node['languages']['python']['version'][0..-3]

if Chef::Config[:solo]
  Chef::Log.warn "This recipe uses encrypted data bags. Chef Solo does not support this."
else
  if node['graphite']['encrypted_data_bag']['name']
    data_bag_name = node['graphite']['encrypted_data_bag']['name']
    password = Chef::EncryptedDataBagItem.load(data_bag_name, "graphite")
  else
    password = node['graphite']['password']
  end
end

%w{ python-cairo-dev python-django python-django-tagging python-memcache python-rrdtool }.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/graphite-web-#{version}.tar.gz" do
  source node['graphite']['graphite_web']['uri']
  checksum node['graphite']['graphite_web']['checksum']
end

execute "untar graphite-web" do
  command "tar xzf graphite-web-#{version}.tar.gz"
  creates "#{Chef::Config[:file_cache_path]}/graphite-web-#{version}"
  cwd Chef::Config[:file_cache_path]
end

execute "install graphite-web" do
  command "python setup.py install"
  creates "#{node['graphite']['doc_root']}/graphite_web-#{version}-py#{pyver}.egg-info"
  cwd "#{Chef::Config[:file_cache_path]}/graphite-web-#{version}"
end

template "/etc/apache2/sites-available/graphite" do
  source "graphite-vhost.conf.erb"
end

apache_site "graphite"

apache_site "000-default" do
  enable false
end

%w{ webapp whisper }.each do |dir|
  directory "#{storagedir}/log/#{dir}" do
    owner node['apache']['user']
    group node['apache']['group']
    recursive true
  end
end

%w{ info.log exception.log access.log error.log }.each do |file|
  file "#{storagedir}/log/webapp/#{file}" do
    owner node['apache']['user']
    group node['apache']['group']
  end
end

template "#{docroot}/graphite/local_settings.py" do
  source "local_settings.py.erb"
  mode 00755
  variables(:timezone => node['graphite']['timezone'],
            :base_dir => node['graphite']['base_dir'],
            :doc_root => node['graphite']['doc_root'],
            :storage_dir => node['graphite']['storage_dir'] )
end

template "#{basedir}/bin/set_admin_passwd.py" do
  source "set_admin_passwd.py.erb"
  mode 00755
end

cookbook_file "#{storagedir}/graphite.db" do
  action :create_if_missing
  notifies :run, "execute[set admin password]"
end

execute "set admin password" do
  command "#{basedir}/bin/set_admin_passwd.py root #{password}"
  action :nothing
end

# This is not done in the cookbook_file above to avoid triggering a password set on permissions changes
file "#{storagedir}/graphite.db" do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00644
end
