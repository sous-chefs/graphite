#
# Cookbook Name:: graphite
# Recipe:: carbon
#
# Copyright 2012, Heavy Water Operations, LLC (OR)
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

include_recipe "#{cookbook_name}::virtualenv"

template "#{node['graphite']['base_dir']}/conf/carbon.conf" do
  owner node['apache']['user']
  group node['apache']['group']
  variables( :carbon => node['graphite']['carbon'].to_hash,
             :line_receiver_interface => node['graphite']['carbon']['line_receiver_interface'],
             :pickle_receiver_interface => node['graphite']['carbon']['pickle_receiver_interface'],
             :cache_query_interface => node['graphite']['carbon']['cache_query_interface'],
             :log_updates => node['graphite']['carbon']['log_updates']
             )
end

template "#{node['graphite']['base_dir']}/conf/storage-schemas.conf" do
  owner node['apache']['user']
  group node['apache']['group']
end

service_type = node['graphite']['carbon']['service_type']
include_recipe "#{cookbook_name}::#{recipe_name}_#{service_type}"
