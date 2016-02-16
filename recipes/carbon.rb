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

service_type = node['graphite']['carbon']['service_type']
include_recipe "#{cookbook_name}::#{recipe_name}_cache_#{service_type}"

package 'python-twisted'
package 'python-simplejson'

case service_type
when 'runit'
  package "graphite-carbon" do
    action :upgrade
    node['graphite']['carbon']['caches'].each do |key,data|
      notifies :restart, "service[carbon-cache-#{key}]"
    end
  end
else
  package "graphite-carbon" do
    action :upgrade
    notifies :restart, 'service[carbon-cache]'
  end
end

directory "#{node['graphite']['base_dir']}/conf" do
  owner node['graphite']['user_account']
  group node['graphite']['group_account']
  recursive true
end

template "#{node['graphite']['base_dir']}/conf/carbon.conf" do
  owner node['graphite']['user_account']
  group node['graphite']['group_account']
  carbon_options = node['graphite']['carbon'].dup
  variables(
    :storage_dir => node['graphite']['storage_dir'],
    :carbon_options => carbon_options
  )
end

directory node['graphite']['storage_dir'] do
  owner node['graphite']['user_account']
  group node['graphite']['group_account']
  recursive true
end

%w{ log whisper rrd }.each do |dir|
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
