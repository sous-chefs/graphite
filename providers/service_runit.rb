#
# Cookbook Name:: graphite
# Provider:: carbon_service_runit
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

action :enable do
  set_updated { manage_runit_service(:enable) }
end

action :disable do
  set_updated { manage_runit_service(:disable) }
end

action :restart do
  set_updated { manage_runit_service(:restart) }
end

action :reload do
  set_updated { manage_runit_service(:reload) }
end

def manage_runit_service(resource_action)
  runit_service(new_resource.service_name) do
    cookbook "graphite"
    run_template_name "carbon"
    default_logger true
    finish_script_template_name "carbon"
    finish true
    options(type: new_resource.type, instance: new_resource.instance)
    action resource_action
  end
end

def set_updated
  r = yield
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end
