#
# Cookbook Name:: graphite
# Recipe:: carbon_aggregator
#
# Copyright 2013, Onddo Labs, SL.
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

service_type = node['graphite']['carbon']['service_type']

case service_type
when 'runit'
  carbon_aggregator_service_resource = 'runit_service[carbon-aggregator]'
else
  carbon_aggregator_service_resource = 'service[carbon-aggregator]'
end

if node['graphite']['storage_aggregation'].length > 0
  template "#{node['graphite']['base_dir']}/conf/storage-aggregation.conf" do
    owner node['apache']['user']
    group node['apache']['group']
    variables( :storage_aggregation => node['graphite']['storage_aggregation'] )
    notifies :restart, carbon_aggregator_service_resource
  end
else
  file "#{node['graphite']['base_dir']}/conf/storage-aggregation.conf" do
    action :delete
    notifies :restart, carbon_aggregator_service_resource
  end
end

include_recipe "#{cookbook_name}::#{recipe_name}_#{service_type}"

