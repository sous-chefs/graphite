#
# Cookbook Name:: graphite
# Provider:: web_config
#
# Copyright (C) 2014  Heavy Water Operations, LLC
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

def whyrun_supported?
  true
end

action :create do
  set_updated { manage_file(:create) }
end

action :delete do
  set_updated { manage_file(:delete) }
end

def manage_file(resource_action)
  contents = "# This file is managed by Chef, your changes *will* be overwritten!\n\n"
  contents << ChefGraphite::PythonWriter.new(new_resource.config, upcase_root_keys: true).to_s
  contents << optimistic_loader_code

  file new_resource.path do
    content contents
    action resource_action
  end
end

def set_updated
  r = yield
  new_resource.updated_by_last_action(r.updated_by_last_action?)
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
  ::File.basename(new_resource.dynamic_template, ".py")
end
