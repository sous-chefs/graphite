#
# Cookbook:: graphite
# Recipe:: _carbon_packages
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

# sadly, have to pin Twisted to known good version
# install before carbon so it's used

# Compliler is needed to build Twisted gem on this step
package platform_family?('debian') ? 'build-essential' : 'gcc'

python_package 'Twisted' do
  user node['graphite']['user']
  group node['graphite']['group']
  version lazy { node['graphite']['twisted_version'] }
  virtualenv node['graphite']['base_dir']
end

python_package 'carbon' do
  package_name lazy {
    node['graphite']['package_names']['carbon'][node['graphite']['install_type']]
  }
  version lazy {
    node['graphite']['install_type'] == 'package' ? node['graphite']['version'] : nil
  }
  user node['graphite']['user']
  group node['graphite']['group']
  install_options '--no-binary=:all:'
  virtualenv node['graphite']['base_dir']
end
