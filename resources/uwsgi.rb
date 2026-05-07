# frozen_string_literal: true

provides :graphite_uwsgi
unified_mode true

use '_partial/_paths'

property :socket, String, default: '/tmp/uwsgi.sock'
property :socket_permissions, String, default: '755'
property :socket_user, String, default: 'graphite'
property :socket_group, String, default: 'graphite'
property :workers, Integer, default: 8
property :carbon, [String, nil], default: '127.0.0.1:2003'
property :listen_http, [true, false], default: false
property :port, Integer, default: 8080
property :buffer_size, String, default: '4096'
property :limit_nofile, Integer, default: 1024

default_action %i(create enable start)

action :create do
  systemd_unit 'graphite-web.socket' do
    content socket_unit_content
    verify false
    action :create
  end

  systemd_unit 'graphite-web.service' do
    content service_unit_content
    action :create
  end
end

action :enable do
  service 'graphite-web' do
    supports status: true
    action :enable
  end
end

action :start do
  service 'graphite-web' do
    supports status: true
    action :start
  end
end

action :stop do
  service 'graphite-web' do
    supports status: true
    action :stop
  end
end

action :disable do
  service 'graphite-web' do
    supports status: true
    action :disable
  end
end

action :delete do
  service 'graphite-web' do
    supports status: true
    action %i(stop disable)
  end

  systemd_unit 'graphite-web.service' do
    action :delete
  end

  systemd_unit 'graphite-web.socket' do
    action :delete
  end
end

action_class do
  def socket_unit_content
    {
      'Unit' => { 'Description' => 'Socket for uWSGI app' },
      'Socket' => {
        'ListenStream' => new_resource.socket,
        'SocketUser' => new_resource.socket_user,
        'SocketGroup' => new_resource.socket_group,
        'SocketMode' => new_resource.socket_permissions,
      },
      'Install' => { 'WantedBy' => 'multi-user.target' },
    }
  end

  def service_unit_content
    {
      'Unit' => {
        'Description' => 'Graphite Web',
        'After' => 'network.target',
        'Requires' => 'graphite-web.socket',
      },
      'Service' => {
        'Type' => 'simple',
        'ExecStart' => uwsgi_command,
        'User' => new_resource.user,
        'Group' => new_resource.group,
        'Restart' => 'on-abort',
        'LimitNOFILE' => new_resource.limit_nofile,
      },
      'Install' => { 'WantedBy' => 'multi-user.target' },
    }
  end

  def uwsgi_command
    command = "#{new_resource.base_dir}/bin/uwsgi --processes #{new_resource.workers}"
    command += " --plugins carbon --carbon #{new_resource.carbon}" if new_resource.carbon
    command += " --http :#{new_resource.port}" if new_resource.listen_http
    command += " --pythonpath #{new_resource.base_dir}/lib"
    command += " --pythonpath #{new_resource.base_dir}/webapp/graphite"
    command += " --wsgi-file #{new_resource.base_dir}/conf/graphite.wsgi.example"
    command += " --chmod-socket=#{new_resource.socket_permissions}"
    command += ' --no-orphans --master'
    command += " --buffer-size #{new_resource.buffer_size}"
    command += ' --procname graphite-web --die-on-term'
    command += " --socket #{new_resource.socket}"
    command
  end
end
