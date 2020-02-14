#
# Cookbook:: graphite
# Resource:: storage
#
# Copyright:: 2014-2016, Heavy Water Software Inc.
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

property :prefix, String, name_property: true
property :package_name, String, default: 'whisper'
property :version, String
property :type, String, default: 'whisper'

action :create do
  manage_python_pip(:install)
  manage_directory(:create)
end

action :upgrade do
  manage_python_pip(:upgrade)
  manage_directory(:create)
end

action :delete do
  manage_python_pip(:remove)
  manage_directory(:delete)
end

action_class do
  def manage_python_pip(resource_action)
    pyenv_pip new_resource.package_name do
      action resource_action

      virtualenv node['graphite']['base_dir']
      user node['graphite']['user']
      version new_resource.version if new_resource.version
      Chef::Log.info 'Installing whisper pip package'
      options '--no-binary=:all:'
    end
  end

  def manage_directory(resource_action)
    directory new_resource.prefix do
      recursive true
      Chef::Log.info "Removing storage path: #{new_resource.prefix}"
      action resource_action
    end
  end
end
