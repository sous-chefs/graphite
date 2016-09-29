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

if node['graphite']['web_server'] == 'apache'
  graphite_web_service_resource = 'service[apache2]'
else
  graphite_web_service_resource = "#{'runit_' if node['graphite']['uwsgi']['service_type'] == 'runit'}service[graphite-web]"
end

password = node['graphite']['password']
if node['graphite']['encrypted_data_bag']['name']
  data_bag_name = node['graphite']['encrypted_data_bag']['name']
  data_bag_item = Chef::EncryptedDataBagItem.load(data_bag_name, 'graphite')
  password = data_bag_item['web_password']
else
  Chef::Log.warn 'This recipe uses encrypted data bags for graphite password but no encrypted data bag name is specified - fallback to node attribute.'
end

case node['platform_family']
when 'rhel', 'fedora'
  package 'uwsgi-plugin-carbon' do
    action [:install, :upgrade]
  end
end

package 'graphite-web' do
  case node['platform_family']
  when 'debian'
    # The package is attempting to overwrite /etc/graphite/local_settings.py,
    # which causes a conflict.  We want the old version.
    options "-o Dpkg::Options::='--force-confold'"
  end
  action :upgrade
  notifies :restart, graphite_web_service_resource
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

execute 'config selinux context' do
  command "chcon -R -h -t httpd_log_t #{storagedir}/log/webapp"
  only_if 'sestatus | grep enabled'
end

directory "#{docroot}/graphite" do
  owner node['graphite']['user_account']
  group node['graphite']['group_account']
  recursive true
end

template "/etc/graphite/local_settings.py" do
  source 'local_settings.py.erb'
  mode 00755
  variables(:timezone => node['graphite']['timezone'],
            :debug => node['graphite']['web']['debug'],
            :base_dir => node['graphite']['base_dir'],
            :doc_root => node['graphite']['doc_root'],
            :storage_dir => node['graphite']['storage_dir'],
            :cluster_servers => node['graphite']['web']['cluster_servers'],
            :carbonlink_hosts => node['graphite']['web']['carbonlink_hosts'],
            :memcached_hosts => node['graphite']['web']['memcached_hosts'],
            :database => node['graphite']['web']['database'],
            :ldap => node['graphite']['web']['ldap'],
            :remote_user_auth => node['graphite']['web']['auth']['REMOTE_USER_AUTH'],
            :login_url => node['graphite']['web']['auth']['LOGIN_URL'],
            :email => node['graphite']['web']['email'],
            :memcached_seconds => node['graphite']['web']['memcached_seconds'])
  notifies :restart, graphite_web_service_resource
end

template "#{basedir}/conf/graphTemplates.conf" do
  source 'graphTemplates.conf.erb'
  mode 00755
  variables(
    :graph_templates => node['graphite']['graph_templates']
  )
  notifies :restart, graphite_web_service_resource
end

# Ubuntu modifies some of Graphite's base layout and does it in ways that aren't
# friendly to reconfiguring, even with the out of the box supported routes, like
# the local_settings.py file. This updates the search index script to put the
# index where the storage directory is located in Chef. Ubuntu changes the
# content of the script, and moves it, and the new location is what is
# referenced by the cronjob to rebuild indexes.
template "/usr/bin/graphite-build-search-index" do
  source "build-search-index.sh.erb"
  mode 00755
end

# While Ubuntu moves the search index script, Graphite has hard coded paths
# inside when it tries to execute it inline. This can cause issues with initial
# installation, where graphite-web can come up, see no idex, and try to build
# one but fail.
directory "/usr/share/graphite-web/bin" do
  recursive true
  action :create
end
link "/usr/share/graphite-web/bin/build-index.sh" do
  to "/usr/bin/graphite-build-search-index"
end

template "#{basedir}/bin/set_admin_passwd.py" do
  source 'set_admin_passwd.py.erb'
  mode 00755
end

cookbook_file "#{storagedir}/graphite.db" do
  action :create_if_missing
  notifies :run, 'execute[set admin password]'
end

execute 'set admin password' do
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
  include_recipe 'graphite::apache'
else
  include_recipe 'graphite::uwsgi'
end
