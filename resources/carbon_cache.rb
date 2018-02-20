#
# Cookbook:: graphite
# Resource:: carbon_cache
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

property :backend, [String, Hash], default: 'whisper'
property :config, [Hash, nil], default: nil

action :create do
  python_package backend_name do
    backend_attributes.each { |attr, value| send(attr, value) }
    Chef::Log.info "Installing storage backend: #{package_name}"
    action :install
    virtualenv node['graphite']['base_dir']
  end
end

action_class do
  def backend_name
    new_resource.backend.is_a?(Hash) ? backend['name'] : new_resource.backend
  end

  def backend_attributes
    if new_resource.backend.is_a?(Hash)
      attrs = new_resource.backend.dup
      attrs.delete('name')
      attrs
    else
      {}
    end
  end
end
