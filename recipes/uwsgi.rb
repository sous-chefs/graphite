#
# Cookbook Name:: graphite
# Recipe:: uwsgi
#
# Copyright 2011, Heavy Water Software Inc.
# Copyright 2013, Enstratius Inc
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

if node['graphite']['listen_port'].to_i < 1024 && node['graphite']['uwsgi']['listen_http']
  Chef::Log.error("uwsgi cannot bind to ports less than 1024. Please set \"node['graphite']['listen_port']\" to an appropriate value")
end

unless node['graphite']['uwsgi'].key?('http-socket')
  Chef::Log.info('You have disabled uwsgi listening on an http port. Graphite web will not be accessible unless you are talking to the uwsgi socket from an external process')
end

service_type = node['graphite']['uwsgi']['service_type']
uwsgi_config = node['graphite']['uwsgi']['config'].dup.delete_if{|k,v| v.nil? }

python_pip 'uwsgi' do
  action :install
end

case node['platform_family']
when 'debian'
  package 'libjansson-dev'
else
  package 'jannson-devel'
end

file 'uwsgi-config' do
  path "#{node['graphite']['base_dir']}/conf/uwsgi-config.json"
  owner node['graphite']['user_account']
  group node['graphite']['group_account']
  content JSON.pretty_generate({ "uwsgi" => uwsgi_config })
  action :create
end

include_recipe "#{cookbook_name}::#{recipe_name}_#{service_type}"
