#
# Cookbook Name:: graphite
# Provider:: carbon_cache
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
  attrs = package_attributes
  p = python_pip package_name do
    attrs.each { |attr, value| send(attr, value) }
  end
  Chef::Log.info "Installing storage backend: #{package_name}"
  new_resource.updated_by_last_action(p.updated_by_last_action?)
end

private

def package_name
  backend = new_resource.backend
  backend.is_a?(Hash) ? backend["name"] : backend
end

def package_attributes
  backend = new_resource.backend
  if backend.is_a? Hash
    attrs = backend.dup
    attrs.delete("name")
    attrs
  else
    Hash.new
  end
end
