#
# Cookbook Name:: graphite
# Recipe:: whisper
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

version = node['graphite']['version']
pyver = node['languages']['python']['version'][0..-3]

remote_file "#{Chef::Config[:file_cache_path]}/whisper-#{version}.tar.gz" do
  source node['graphite']['whisper']['uri']
  checksum node['graphite']['whisper']['checksum']
end

execute "untar whisper" do
  command "tar xzf whisper-#{version}.tar.gz"
  creates "#{Chef::Config[:file_cache_path]}/whisper-#{version}"
  cwd Chef::Config[:file_cache_path]
end

execute "install whisper" do
  command "python setup.py install"
  creates "/usr/local/lib/python#{pyver}/dist-packages/whisper-#{version}.egg-info"
  cwd "#{Chef::Config[:file_cache_path]}/whisper-#{version}"
end
