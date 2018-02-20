#
# Cookbook:: graphite
# Recipe:: _web_packages
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

package node['graphite']['system_packages']

python_package 'django' do
  version lazy { node['graphite']['django_version'] }
  virtualenv '/opt/graphite'
end

# The latest version is 0.4, which causes an importError
# ImportError: No module named fields
# with `python manage.py syncdb --noinput`
python_package 'django-tagging' do
  version '0.3.6'
  virtualenv '/opt/graphite'
end

python_package %w(pytz pyparsing python-memcached cairocffi) do
  virtualenv node['graphite']['base_dir']
end

python_package 'uwsgi' do
  options '--isolated'
  virtualenv '/opt/graphite'
end

python_package 'graphite_web' do
  package_name lazy {
    key = node['graphite']['install_type']
    node['graphite']['package_names']['graphite_web'][key]
  }
  version lazy {
    node['graphite']['version'] if node['graphite']['install_type'] == 'package'
  }
  virtualenv node['graphite']['base_dir']
end
