# frozen_string_literal: true

provides :graphite_service
unified_mode true

use '_partial/_paths'

property :service, String, name_property: true
property :debug, [true, false], default: false
property :limit_nofile, Integer, default: 1024
property :bin_dir, String, default: '/usr/bin'

default_action %i(create enable start)

action :create do
  systemd_unit "#{service_name}.service" do
    content service_unit_content
    action :create
  end
end

action :enable do
  service service_name do
    supports status: true
    action :enable
  end
end

action :start do
  service service_name do
    supports status: true
    action :start
  end
end

action :disable do
  service service_name do
    supports status: true
    action :disable
  end
end

action :stop do
  service service_name do
    supports status: true
    action :stop
  end
end

action :restart do
  service service_name do
    supports status: true
    action :restart
  end
end

action :reload do
  service service_name do
    supports status: true
    action :reload
  end
end

action :delete do
  service service_name do
    supports status: true
    action %i(stop disable)
  end

  systemd_unit "#{service_name}.service" do
    action :delete
  end
end

action_class do
  def service_unit_content
    {
      'Unit' => {
        'Description' => "Graphite Carbon #{carbon_type} #{carbon_instance}",
        'After' => 'network.target',
      },
      'Service' => {
        'Type' => 'simple',
        'ExecStart' => "#{new_resource.bin_dir}/carbon-#{carbon_type} --config=#{new_resource.base_dir}/conf/carbon.conf --pidfile=#{new_resource.storage_dir}/#{service_name}.pid #{exec_attrs}",
        'User' => new_resource.user,
        'Group' => new_resource.group,
        'Restart' => 'on-abort',
        'LimitNOFILE' => new_resource.limit_nofile,
        'PIDFile' => "#{new_resource.storage_dir}/#{service_name}.pid",
      },
      'Install' => { 'WantedBy' => 'multi-user.target' },
    }
  end

  def exec_attrs
    attrs = carbon_instance ? ["--instance #{carbon_instance}"] : []
    attrs << (new_resource.debug ? '--debug' : '--nodaemon')
    attrs << 'start'
    attrs.join(' ')
  end

  def service_name
    'carbon-' + new_resource.service.tr(':', '-')
  end

  def carbon_type
    new_resource.service.split(':').first
  end

  def carbon_instance
    new_resource.service.split(':')[1]
  end
end
