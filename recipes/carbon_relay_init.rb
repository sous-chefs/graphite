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

template "/etc/init.d/carbon-relay" do
  source "carbon-relay.init.erb"
  variables(
    :dir     => node['graphite']['base_dir'],
    :user    => node['apache']['user']
  )
  mode 00744
end

service "carbon-relay" do
  action [:enable, :start]
end
