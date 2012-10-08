#
# Cookbook Name:: graphite
# Recipe:: default
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

include_recipe "python"

%w[conf storage].each do |graphite_directory|
  directory ::File.join(node['graphite']['base_dir'],
                        graphite_directory) do
    owner node['graphite']['virtualenv']['owner']
    group node['graphite']['virtualenv']['group']
    recursive true
  end
end

python_virtualenv node['graphite']['base_dir'] do
  interpreter node['graphite']['virtualenv']['interpreter']
  owner node['graphite']['virtualenv']['owner']
  group node['graphite']['virtualenv']['group']
  options "--system-site-packages"
  action :create
end

%w[whisper carbon graphite-web].each do |graphite_pip_pkg|
  python_pip graphite_pip_pkg do
    version node['graphite']['version']
    virtualenv node['graphite']['base_dir']
    action :install
  end
end
