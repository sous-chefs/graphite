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
  include_recipe "python::pip"
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
  owner node['graphite']['user_account']
  group node['graphite']['group_account']
  variables( # carbon-cache.py
             :storage_dir => node['graphite']['storage_dir'],
             :max_cache_size => node['graphite']['carbon']['max_cache_size'],
             :max_updates_per_second => node['graphite']['carbon']['max_updates_per_second'],
             :max_creates_per_second => node['graphite']['carbon']['max_creates_per_second'],
             :line_receiver_interface => node['graphite']['carbon']['line_receiver_interface'],
             :line_receiver_port => node['graphite']['carbon']['line_receiver_port'],
             :enable_udp_listener => node['graphite']['carbon']['enable_udp_listener'],
             :udp_receiver_interface => node['graphite']['carbon']['udp_receiver_interface'],
             :udp_receiver_port => node['graphite']['carbon']['udp_receiver_port'],
             :pickle_receiver_interface => node['graphite']['carbon']['pickle_receiver_interface'],
             :pickle_receiver_port => node['graphite']['carbon']['pickle_receiver_port'],
             :use_insecure_unpickler => node['graphite']['carbon']['use_insecure_unpickler'],
             :cache_query_interface => node['graphite']['carbon']['cache_query_interface'],
             :cache_query_port => node['graphite']['carbon']['cache_query_port'],
             :use_flow_control => node['graphite']['carbon']['use_flow_control'],
             :log_whisper_updates => node['graphite']['carbon']['log_whisper_updates'],
             :whisper_autoflush => node['graphite']['carbon']['whisper_autoflush'],
             :enable_amqp => node['graphite']['carbon']['enable_amqp'],
             :amqp_host => node['graphite']['carbon']['amqp_host'],
             :amqp_port => node['graphite']['carbon']['amqp_port'],
             :amqp_vhost => node['graphite']['carbon']['amqp_vhost'],
             :amqp_user => node['graphite']['carbon']['amqp_user'],
             :amqp_password => node['graphite']['carbon']['amqp_password'],
             :amqp_exchange => node['graphite']['carbon']['amqp_exchange'],
             :amqp_metric_name_in_body => node['graphite']['carbon']['amqp_metric_name_in_body'],

             # carbon-relay.py
             :relay_line_receiver_interface => node['graphite']['carbon']['relay']['line_receiver_interface'],
             :relay_line_receiver_port => node['graphite']['carbon']['relay']['line_receiver_port'],
             :relay_pickle_receiver_interface => node['graphite']['carbon']['relay']['pickle_receiver_interface'],
             :relay_pickle_receiver_port => node['graphite']['carbon']['relay']['pickle_receiver_port'],
             :relay_method => node['graphite']['carbon']['relay']['relay_method'],
             :relay_replication_factor => node['graphite']['carbon']['relay']['replication_factor'],
             :relay_destinations => node['graphite']['carbon']['relay']['destinations'],
             :relay_max_datapoints_per_message => node['graphite']['carbon']['relay']['max_datapoints_per_message'],
             :relay_max_queue_size => node['graphite']['carbon']['relay']['max_queue_size'],
             :relay_use_flow_control => node['graphite']['carbon']['relay']['use_flow_control'],

             # carbon-aggregator.py
             :aggregator_line_receiver_interface => node['graphite']['carbon']['aggregator']['line_receiver_interface'],
             :aggregator_line_receiver_port => node['graphite']['carbon']['aggregator']['line_receiver_port'],
             :aggregator_pickle_receiver_interface => node['graphite']['carbon']['aggregator']['pickle_receiver_interface'],
             :aggregator_pickle_receiver_port => node['graphite']['carbon']['aggregator']['pickle_receiver_port'],
             :aggregator_destinations => node['graphite']['carbon']['aggregator']['destinations'],
             :aggregator_replication_factor => node['graphite']['carbon']['aggregator']['replication_factor'],
             :aggregator_max_queue_size => node['graphite']['carbon']['aggregator']['max_queue_size'],
             :aggregator_use_flow_control => node['graphite']['carbon']['aggregator']['use_flow_control'],
             :aggregator_max_datapoints_per_message => node['graphite']['carbon']['aggregator']['max_datapoints_per_message'],
             :aggregator_max_aggregation_intervals => node['graphite']['carbon']['aggregator']['max_aggregation_intervals']
  )
  notifies :restart, carbon_cache_service_resource
end

%w{ schemas aggregation }.each do |storage_feature|
  storage_config = node['graphite']['storage_' + storage_feature]

  template "#{node['graphite']['base_dir']}/conf/storage-#{storage_feature}.conf" do
    source 'storage.conf.erb'
    owner node['graphite']['user_account']
    group node['graphite']['group_account']
    variables({:storage_config => storage_config})
    only_if { storage_config.is_a?(Array) }
  end
end

directory node['graphite']['storage_dir'] do
  owner node['graphite']['user_account']
  group node['graphite']['group_account']
  recursive true
end

%w{ log whisper }.each do |dir|
  directory "#{node['graphite']['storage_dir']}/#{dir}" do
    owner node['graphite']['user_account']
    group node['graphite']['group_account']
  end
end

directory "#{node['graphite']['base_dir']}/lib/twisted/plugins/" do
  owner node['graphite']['user_account']
  group node['graphite']['group_account']
  recursive true
end

service_type = node['graphite']['carbon']['service_type']
include_recipe "#{cookbook_name}::#{recipe_name}_#{service_type}"
