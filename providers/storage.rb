#
# Cookbook Name:: graphite
# Provider:: storage
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

def whyrun_supported?
  true
end

use_inline_resources

action :create do
  p = python_pip package_name do
    version new_resource.version if new_resource.version

    Chef::Log.info 'Installing whisper pip package'
    action :install
  end
  new_resource.updated_by_last_action(p.updated_by_last_action?)
  d = directory new_resource.prefix do
    recursive true
    Chef::Log.info "Removing storage path: #{new_resource.prefix}"
  end
  new_resource.updated_by_last_action(d.updated_by_last_action?)
end

action :delete do
  p = python_pip package_name do
    action :remove
    Chef::Log.info 'Uninstalling whisper pip package'
  end
  new_resource.updated_by_last_action(p.updated_by_last_action?)

  d = directory new_resource.prefix do
    recursive true
    action :delete
    Chef::Log.info "Removing storage path: #{new_resource.prefix}"
  end
  new_resource.updated_by_last_action(d.updated_by_last_action?)
end

private

def package_name
  new_resource.package_name || 'whisper'
end
