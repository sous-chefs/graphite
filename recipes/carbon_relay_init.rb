#
# Cookbook Name:: graphite
# Recipe:: carbon_relay_init
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

template '/etc/init.d/carbon-relay-a' do
  source 'carbon.init.erb'
  variables(
    :name    => 'relay',
    :dir     => node['graphite']['base_dir'],
    :user    => node['graphite']['user_account'],
    :instance => 'a'
  )
  mode 00744
  notifies :restart, 'service[carbon-relay-a]'
end

service 'carbon-relay-a' do
  action [:enable, :start]
  subscribes :restart, "template[#{node['graphite']['base_dir']}/conf/carbon.conf]"
end

if node['graphite']['carbon']['relay']['instances'].length > 0
    node['graphite']['carbon']['relay']['instances'].each do |instance|
      template "/etc/init.d/carbon-relay-#{instance['instance_name']}" do
      source 'carbon.init.erb'
      variables(
        :name    => 'relay',
        :dir     => node['graphite']['base_dir'],
        :user    => node['graphite']['user_account'],
        :instance => instance['instance_name']
      )
      mode 00744
      notifies :restart, "service[carbon-relay-#{instance['instance_name']}]"
    end

    service "carbon-relay-#{instance['instance_name']}" do
      action [:enable, :start]
      subscribes :restart, "template[#{node['graphite']['base_dir']}/conf/carbon.conf]"
    end
  end
end