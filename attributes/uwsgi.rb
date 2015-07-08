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

default['graphite']['uwsgi']['service_type'] = 'runit'

basedir = default['graphite']['base_dir']

default['graphite']['uwsgi']['config'] = {
    "processes" => 8,
    "plugins" => [
        "carbon --carbon 127.0.0.1:2003"
    ],
    "pythonpath" => [
        "#{basedir}/lib",
        "#{basedir}/webapp/graphite"
    ],
    "wsgi-file" => "#{basedir}/conf/graphite.wsgi.example",
    "uid" => default['graphite']['user'],
    "gid" => default['graphite']['group'],
    "no-orphans" => true,
    "master" => true,
    "die-on-term" => true,
    "socket" => "/tmp/uwsgi.sock"
}
