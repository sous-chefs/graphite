unified_mode true
#
# Cookbook:: graphite
# Resource:: web_config
#
# Copyright:: 2014-2016, Heavy Water Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

property :path, String, name_property: true
property :config, [Hash, nil], default: nil
property :dynamic_template, String, default: 'local_settings_dynamic.py'

action :create do
  manage_file(:create)
end

action :delete do
  manage_file(:delete)
end

action_class do
  def manage_file(resource_action)
    contents = "# This file is managed by Chef, your changes *will* be overwritten!\n\n"
    contents << ChefGraphite::PythonWriter.new(new_resource.config, upcase_root_keys: true).to_s
    contents << optimistic_loader_code

    file new_resource.path do
      content contents
      action resource_action
    end
  end

  def optimistic_loader_code
    <<-EOF

try:
  from graphite.#{dynamic_template_name} import *
except ImportError:
  pass

    EOF
  end

  def dynamic_template_name
    ::File.basename(new_resource.dynamic_template, '.py')
  end
end
