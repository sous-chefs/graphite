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
    service_unit_content = {
      'Unit' => {
        'Description' => "Graphite Carbon #{type} #{instance}",
        'After' => 'network.target auditd.service',
      },
      'Service' => {
        'Type' => 'forking',
        'ExecStartPre' => "/bin/rm -f #{node['graphite']['storage_dir']}/carbon#{type}#{instance}.pid",
        'ExecStart' => "#{node['graphite']['base_dir']}/bin/carbon-#{type}.py --pidfile=#{node['graphite']['storage_dir']}/carbon#{type}#{instance} --debug start",
        'User' => node['graphite']['user'],
        'LimitNOFILE' => node['graphite']['limits']['nofile'],
        'PIDFile' => "#{node['graphite']['storage_dir']}/carbon#{type}#{instance}.pid",
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
