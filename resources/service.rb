#
# Cookbook:: graphite
# Resource:: carbon_service
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

property :name, String, name_property: true

action :enable do
  manage_runit_service(:enable)
end

action :disable do
  manage_runit_service(:disable)
end

action :restart do
  manage_runit_service(:restart)
end

action :reload do
  manage_runit_service(:reload)
end

action_class do
  def manage_runit_service(resource_action)
    runit_service(service_name) do
      cookbook 'graphite'
      run_template_name 'carbon'
      default_logger true
      finish_script_template_name 'carbon'
      finish true
      options(type: type, instance: instance)
      action resource_action
    end
  end

  def service_name
    'carbon-' + new_resource.name.tr(':', '-')
  end

  def type
    t, = new_resource.name.split(':')
    t
  end

  def instance
    _, i = new_resource.name.split(':')
    i
  end
end
