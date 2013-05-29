#
# Cookbook Name:: graphite
# Recipe:: carbon_cache_upstart
#
# Copyright 2013, Heavy Water Software Inc.
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


template "/etc/init/carbon-cache.conf" do
  source "carbon.upstart.erb"
  variables(
    :name    => 'cache',
    :dir     => node['graphite']['base_dir'],
    :user    => node['apache']['user']
  )
  mode 00644
end

service "carbon-cache" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true, :status => true
  action [:enable, :start]
end
