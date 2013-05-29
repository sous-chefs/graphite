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

basedir = node['graphite']['base_dir']
docroot = node['graphite']['doc_root']
storagedir = node['graphite']['storage_dir']
version = node['graphite']['version']
pyver = node['languages']['python']['version'][0..-3]

if node['graphite']['web_server'] == 'apache'
  graphite_web_service_resource = 'service[apache2]'
else
  graphite_web_service_resource = 'runit_service[graphite-web]'
end

password = node['graphite']['password']
if node['graphite']['encrypted_data_bag']['name']
  data_bag_name = node['graphite']['encrypted_data_bag']['name']
  data_bag_item = Chef::EncryptedDataBagItem.load(data_bag_name, 'graphite')
  password = data_bag_item['web_password']
else
  Chef::Log.warn "This recipe uses encrypted data bags for graphite password but no encrypted data bag name is specified - fallback to node attribute."
end

dep_packages = case node['platform_family']
               when "debian"
                 packages = %w{ python-cairo-dev python-django python-django-tagging python-memcache python-rrdtool }
               when "rhel", "fedora"
                 packages = %w{ Django django-tagging pycairo-devel python-devel python-memcached mod_wsgi python-sqlite2 python-zope-interface }

                 # Include bitmap packages (optionally)
                 if node['graphite']['graphite_web']['bitmap_support']
                   %w{bitmap bitmap-fonts} + packages
                 else
                   packages
                 end

               end

dep_packages.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "#{Chef::Config[:file_cache_path]}/graphite-web-#{version}.tar.gz" do
  source node['graphite']['web']['uri']
  checksum node['graphite']['web']['checksum']
end

execute "untar graphite-web" do
  command "tar xzf graphite-web-#{version}.tar.gz"
  creates "#{Chef::Config[:file_cache_path]}/graphite-web-#{version}"
  cwd Chef::Config[:file_cache_path]
end

execute "install graphite-web" do
  command "python setup.py install --prefix=#{node['graphite']['base_dir']} --install-lib=#{node['graphite']['doc_root']}"
  creates "#{node['graphite']['doc_root']}/graphite_web-#{version}-py#{pyver}.egg-info"
  cwd "#{Chef::Config[:file_cache_path]}/graphite-web-#{version}"
end

directory "#{storagedir}/log/webapp" do
  owner node['graphite']['user_account']
  group node['graphite']['group_account']
  recursive true
end

%w{ info.log exception.log access.log error.log }.each do |file|
  file "#{storagedir}/log/webapp/#{file}" do
    owner node['graphite']['user_account']
    group node['graphite']['group_account']
  end
end

template "#{docroot}/graphite/local_settings.py" do
  source "local_settings.py.erb"
  mode 00755
  variables(:timezone => node['graphite']['timezone'],
            :debug => node['graphite']['web']['debug'],
            :base_dir => node['graphite']['base_dir'],
            :doc_root => node['graphite']['doc_root'],
            :storage_dir => node['graphite']['storage_dir'],
            :cluster_servers => node['graphite']['web']['cluster_servers'],
            :carbonlink_hosts => node['graphite']['web']['carbonlink_hosts'] )
  notifies :reload, graphite_web_service_resource
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
  owner node['graphite']['user_account']
  group node['graphite']['group_account']
  mode 00644
end

if node['graphite']['web_server'] == 'apache'
  include_recipe "graphite::apache"
else
  include_recipe "graphite::uwsgi"
end
