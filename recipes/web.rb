#
# Cookbook Name:: graphite
# Recipe:: web
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

include_recipe 'python'
include_recipe 'python::pip'

include_recipe 'graphite::_user'
include_recipe 'graphite::_web_packages'
include_recipe 'graphite::_directories'

basedir = node['graphite']['base_dir']
docroot = node['graphite']['doc_root']
storagedir = node['graphite']['storage_dir']

directory "#{storagedir}/log/webapp" do
  owner node['graphite']['user']
  group node['graphite']['group']
  recursive true
end

%w{ info.log exception.log access.log error.log }.each do |file|
  file "#{storagedir}/log/webapp/#{file}" do
    owner node['graphite']['user']
    group node['graphite']['group']
  end
end

execute 'config selinux context' do
  command "chcon -R -h -t httpd_log_t #{storagedir}/log/webapp"
  only_if 'sestatus | grep enabled'
end

directory "#{docroot}/graphite" do
  owner node['graphite']['user']
  group node['graphite']['group']
  recursive true
end

template "#{basedir}/conf/graphTemplates.conf" do
  source 'graphTemplates.conf.erb'
  mode 00755
  variables(
    graph_templates: node['graphite']['graph_templates']
  )
end
