#
# Cookbook Name:: graphite
# Recipe:: carbon_relay_runit
#
# Copyright 2013, Onddo Labs, SL.
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

include_recipe "runit"

runit_service "carbon-relay" do
  run_template_name 'carbon'
  log_template_name 'carbon'
  finish_script_template_name 'carbon'
  finish true
  options(:name => 'relay')
  subscribes :restart, "template[#{node['graphite']['base_dir']}/conf/carbon.conf]"
end
