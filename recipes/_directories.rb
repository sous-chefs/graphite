#
# Cookbook Name:: graphite
# Recipe:: _directories
#
# Copyright 2014, Heavy Water Software Inc.
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

path = node['graphite']['storage_dir']

directory path do
  owner node['graphite']['user']
  group node['graphite']['group']
  recursive true
end

%w{ log whisper rrd }.each do |dir|
  directory "#{path}/#{dir}" do
    owner node['graphite']['user']
    group node['graphite']['group']
    recursive true
  end
end
