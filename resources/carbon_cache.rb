#
# Cookbook Name:: graphite
# Resource:: carbon_cache
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

actions :create, :delete
default_action :create

attribute :name, kind_of: String, default: nil, name_attribute: true
attribute :backend, kind_of: [String, Hash], default: "whisper"
attribute :config, kind_of: Hash, default: nil

def backend_name
  backend.is_a?(Hash) ? backend["name"] : backend
end

def backend_attributes
  if backend.is_a?(Hash)
    attrs = backend.dup
    attrs.delete("name")
    attrs
  else
    Hash.new
  end
end
