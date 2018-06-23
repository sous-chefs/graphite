#
# Cookbook:: graphite
# Recipe:: uwsgi
#
# Copyright:: 2014-2016, Heavy Water Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

command = "#{node['graphite']['base_dir']}/bin/uwsgi --processes #{node['graphite']['uwsgi']['workers']}"
command << " --plugins carbon --carbon #{node['graphite']['uwsgi']['carbon']}" if node['graphite']['uwsgi']['carbon']
command << " --http :#{node['graphite']['uwsgi']['port']}" if node['graphite']['uwsgi']['listen_http']
command << " --pythonpath #{node['graphite']['base_dir']}/lib \
--pythonpath #{node['graphite']['base_dir']}/webapp/graphite \
--wsgi-file #{node['graphite']['base_dir']}/conf/graphite.wsgi.example \
--chmod-socket=#{node['graphite']['uwsgi']['socket_permissions']} \
--no-orphans --master \
--buffer-size #{node['graphite']['uwsgi']['buffer-size']} \
--procname graphite-web \
--die-on-term \
--socket #{node['graphite']['uwsgi']['socket']}"

socket_unit_content = {
  'Unit' => {
    'Description' => 'Socket for uWSGI app'
  },
  'Socket' => {
    'ListenStream' => node['graphite']['uwsgi']['socket'],
    "SocketUser" => node['graphite']['uwsgi']['socket_user'],
    "SocketGroup" => node['graphite']['uwsgi']['socket_group'],
    "SocketMode" => node['graphite']['uwsgi']['socket_permissions']
  },
  'Install' => { 'WantedBy' => 'multi-user.target' },
}

systemd_unit 'graphite-web.socket' do
  content socket_unit_content
  verify false
  action :create
  notifies(:restart, 'service[graphite-web]')
end

service_unit_content = {
  'Unit' => {
    'Description' => 'Graphite Web',
    'After' => 'network.target',
    'Requires' => 'graphite-web.socket'
  },
  'Service' => {
    'Type' => 'simple',
    'ExecStart' => command,
    'User' => node['graphite']['user'],
    'Group' => node['graphite']['group'],
    'Restart' => 'on-abort',
    'LimitNOFILE' => node['graphite']['limits']['nofile'],
  },
  'Install' => { 'WantedBy' => 'multi-user.target' },
}

systemd_unit 'graphite-web.service' do
  content service_unit_content
  action :create
  notifies(:restart, 'service[graphite-web]')
end

service 'graphite-web' do
  supports status: true
  action [:start, :enable]
end
