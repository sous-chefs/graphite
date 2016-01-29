#
# Cookbook Name:: graphite
# Attributes:: default
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

default['graphite']['version'] = '0.9.12'
default['graphite']['twisted_version'] = '13.1.0'
default['graphite']['django_version'] = '1.5.5'
default['graphite']['password'] = 'change_me'
default['graphite']['user'] = 'graphite'
default['graphite']['group'] = 'graphite'
default['graphite']['base_dir'] = '/opt/graphite'
default['graphite']['doc_root'] = '/opt/graphite/webapp'
default['graphite']['limits']['nofile'] = 1024
default['graphite']['storage_dir'] = '/opt/graphite/storage'
default['graphite']['install_type'] = 'package'
default['graphite']['package_names'] = {
  'whisper' => {
    'package' => 'whisper',
    'source' => 'https://github.com/graphite-project/whisper/zipball/master'
  },
  'carbon' => {
    'package' => 'carbon',
    'source' => 'https://github.com/graphite-project/carbon/zipball/master'
  },
  'graphite_web' => {
    'package' => 'graphite-web',
    'source' => 'https://github.com/graphite-project/graphite-web/zipball/master'
  }
}

default['graphite']['graph_templates'] = [
  {
    'name' => 'default',
    'background' => 'black',
    'foreground' => 'white',
    'majorLine' => 'white',
    'minorLine' => 'grey',
    'lineColors' => 'blue,green,red,purple,brown,yellow,aqua,grey,magenta,pink,gold,rose',
    'fontName' => 'Sans',
    'fontSize' => '10',
    'fontBold' => 'False',
    'fontItalic' => 'False'
  }
]

default['graphite']['system_packages'] =
  case node['platform_family']
  when 'debian'
    %w{python-cairo-dev python-rrdtool}
  when 'rhel'
    case node['platform']
    when 'amazon'
      %w{pycairo-devel python-rrdtool bitmap}
    else
      %w{pycairo-devel python-rrdtool bitmap bitmap-fonts}
    end
  else
    []
  end
