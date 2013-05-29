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

  amqp_password = node['graphite']['carbon']['amqp_password']
  if node['graphite']['encrypted_data_bag']['name']
    data_bag_name = node['graphite']['encrypted_data_bag']['name']
    data_bag_item = Chef::EncryptedDataBagItem.load(data_bag_name, 'graphite')
    amqp_password = data_bag_item['amqp_password']
  else
    Chef::Log.warn "This recipe uses encrypted data bags for carbon AMQP password but no encrypted data bag name is specified - fallback to node attribute."
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

template "#{node['graphite']['base_dir']}/conf/carbon.conf" do
  owner node['graphite']['user_account']
  group node['graphite']['group_account']
  carbon_options = node['graphite']['carbon'].dup
  carbon_options['amqp_password'] = amqp_password unless amqp_password.nil?
  variables( :storage_dir => node['graphite']['storage_dir'],
             :carbon_options => carbon_options
  )
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

