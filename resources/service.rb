#
# Cookbook Name:: graphite
# Resource:: carbon_service
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

actions :enable, :disable, :restart, :reload
default_action :enable

attribute :name, kind_of: String, default: nil, name_attribute: true

def initialize(*args)
  super
  @provider = Chef::Provider::GraphiteServiceRunit
end

def service_name
  "carbon-" + name.tr(":", "-")
end

def type
  t, _ = name.split(":")
  t
end

def instance
  _, i = name.split(":")
  i
end
