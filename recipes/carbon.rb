#
# Cookbook Name:: graphite
# Recipe:: carbon
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

package "python-twisted"
package "python-simplejson"

if node['graphite']['carbon']['enable_amqp']
  python_pip "txamqp" do
    action :install
  end
end

version = node['graphite']['version']
pyver = node['languages']['python']['version'][0..-3]

remote_file "#{Chef::Config[:file_cache_path]}/carbon-#{version}.tar.gz" do
  source node['graphite']['carbon']['uri']
  checksum node['graphite']['carbon']['checksum']
end

execute "untar carbon" do
  command "tar xzf carbon-#{version}.tar.gz"
  creates "#{Chef::Config[:file_cache_path]}/carbon-#{version}"
  cwd Chef::Config[:file_cache_path]
end

execute "install carbon" do
  command "python setup.py install --prefix=#{node['graphite']['base_dir']} --install-lib=#{node['graphite']['base_dir']}/lib"
  creates "#{node['graphite']['base_dir']}/lib/carbon-#{version}-py#{pyver}.egg-info"
  cwd "#{Chef::Config[:file_cache_path]}/carbon-#{version}"
end

case node['graphite']['carbon']['service_type']
when "runit"
  carbon_cache_service_resource = "runit_service[carbon-cache]"
else
  carbon_cache_service_resource = "service[carbon-cache]"
end

template "#{node['graphite']['base_dir']}/conf/carbon.conf" do
  owner node['apache']['user']
  group node['apache']['group']
  variables( :line_receiver_interface => node['graphite']['carbon']['line_receiver_interface'],
             :line_receiver_port => node['graphite']['carbon']['line_receiver_port'],
             :pickle_receiver_interface => node['graphite']['carbon']['pickle_receiver_interface'],
             :pickle_receiver_port => node['graphite']['carbon']['pickle_receiver_port'],
             :cache_query_interface => node['graphite']['carbon']['cache_query_interface'],
             :cache_query_port => node['graphite']['carbon']['cache_query_port'],
             :max_cache_size => node['graphite']['carbon']['max_cache_size'],
             :max_updates_per_second => node['graphite']['carbon']['max_updates_per_second'],
             :max_creates_per_second => node['graphite']['carbon']['max_creates_per_second'],
             :log_whisper_updates => node['graphite']['carbon']['log_whisper_updates'],
             :enable_amqp => node['graphite']['carbon']['enable_amqp'],
             :amqp_host => node['graphite']['carbon']['amqp_host'],
             :amqp_port => node['graphite']['carbon']['amqp_port'],
             :amqp_vhost => node['graphite']['carbon']['amqp_vhost'],
             :amqp_user => node['graphite']['carbon']['amqp_user'],
             :amqp_password => node['graphite']['carbon']['amqp_password'],
             :amqp_exchange => node['graphite']['carbon']['amqp_exchange'],
             :amqp_metric_name_in_body => node['graphite']['carbon']['amqp_metric_name_in_body'],
             :storage_dir => node['graphite']['storage_dir'])
  notifies :restart, carbon_cache_service_resource
end

%w{ schemas aggregation }.each do |storage_feature|
  storage_config = node['graphite']['storage_' + storage_feature]

  template "#{node['graphite']['base_dir']}/conf/storage-#{storage_feature}.conf" do
    source 'storage.conf.erb'
    owner node['apache']['user']
    group node['apache']['group']
    variables({:storage_config => storage_config})
    only_if { storage_config.is_a?(Array) }
  end
end

directory node['graphite']['storage_dir'] do
  owner node['apache']['user']
  group node['apache']['group']
  recursive true
end

%w{ log whisper }.each do |dir|
  directory "#{node['graphite']['storage_dir']}/#{dir}" do
    owner node['apache']['user']
    group node['apache']['group']
  end
end

directory "#{node['graphite']['base_dir']}/lib/twisted/plugins/" do
  owner node['apache']['user']
  group node['apache']['group']
  recursive true
end

service_type = node['graphite']['carbon']['service_type']
include_recipe "#{cookbook_name}::#{recipe_name}_#{service_type}"
