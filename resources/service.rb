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

action :enable do
  manage_systemd_service(:enable)
end

action :disable do
  manage_systemd_service(:disable)
end

action :restart do
  manage_systemd_service(:restart)
end

action :reload do
  manage_systemd_service(:reload)
end

action_class do
  def manage_systemd_service(resource_action)
    virtual_env_path = "#{node['graphite']['base_dir']}/bin"

    service_unit_content = {
      'Unit' => {
        'Description' => "Graphite Carbon #{type} #{instance}",
        'After' => 'network.target',
      },
      'Service' => {
        'Type' => 'simple',
        'ExecStart' => "#{virtual_env_path}/python #{virtual_env_path}/carbon-#{type}.py --debug start",
        'User' => node['graphite']['user'],
        'Group' => node['graphite']['group'],
        'Restart' => 'on-abort',
        'LimitNOFILE' => node['graphite']['limits']['nofile'],
        'PIDFile' => "#{node['graphite']['storage_dir']}/#{service_name}.pid",
      },
      'Install' => { 'WantedBy' => 'multi-user.target' },
    }

    systemd_unit "#{service_name}.service" do
      content service_unit_content
      action :create
      notifies(:restart, "service[#{service_name}]")
    end

    service service_name do
      supports status: true
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
