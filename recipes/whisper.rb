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

python_pip 'whisper' do
  package_name lazy {
    node['graphite']['package_names']['whisper'][node['graphite']['install_type']]
  }
  version lazy {
    node['graphite']['install_type'] == 'package' ? node['graphite']['version'] : nil
  }
end

directory "#{node['graphite']['base_dir']}/bin/" do
  recursive true
end

template "#{node['graphite']['base_dir']}/bin/whisper-clean.py" do
  source 'whisper-clean.py.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(:storage_dir => node['graphite']['storage_dir'])
end
