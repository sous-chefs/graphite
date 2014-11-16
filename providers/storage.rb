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

action :create do
  set_updated { manage_python_pip(:install) }
  set_updated { manage_directory(:create) }
end

action :upgrade do
  set_updated { manage_python_pip(:upgrade) }
  set_updated { manage_directory(:create) }
end

action :delete do
  set_updated { manage_python_pip(:remove) }
  set_updated { manage_directory(:delete) }
end

def manage_python_pip(resource_action)
  python_pip package_name do
    version new_resource.version if new_resource.version
    Chef::Log.info 'Installing whisper pip package'
    action resource_action
  end
end

def manage_directory(resource_action)
  directory new_resource.prefix do
    recursive true
    Chef::Log.info "Removing storage path: #{new_resource.prefix}"
    action resource_action
  end
end

def set_updated
  r = yield
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end

def package_name
  new_resource.package_name || 'whisper'
end
