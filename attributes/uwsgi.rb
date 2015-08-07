#
# Cookbook Name:: graphite
# Attributes:: uwsgi
#
# Copyright 2014, Heavy Water Ops, LLC
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

default['graphite']['uwsgi']['socket'] = '/tmp/uwsgi.sock'
default['graphite']['uwsgi']['socket_permissions'] = '755'
default['graphite']['uwsgi']['workers'] = 8
default['graphite']['uwsgi']['carbon'] = '127.0.0.1:2003'
default['graphite']['uwsgi']['listen_http'] = false
default['graphite']['uwsgi']['port'] = 8080
default['graphite']['uwsgi']['service_type'] = 'runit'
