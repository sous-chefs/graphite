#
# Cookbook Name:: graphite
# Recipe:: federated
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

#
# This is an example of an Application Recipe for a Federated Graphite configuration.
#
# Heavily based on Richard Crowley's blog example:
# http://rcrowley.org/articles/federated-graphite.html
#

node.default['graphite']['carbon']['line_receiver_port'] = 2013
node.default['graphite']['carbon']['udp_receiver_port'] = 2013
node.default['graphite']['carbon']['pickle_receiver_port'] = 2014

node.default['graphite']['carbon']['relay']['line_receiver_port'] = 2003
node.default['graphite']['carbon']['relay']['udp_receiver_port'] = 2003
node.default['graphite']['carbon']['relay']['pickle_receiver_port'] = 2004
node.default['graphite']['carbon']['relay']['relay_method'] = "consistent-hashing"

int_instances = []
ext_instances = []

if Chef::Config[:solo]
  node.default['graphite']['carbon']['relay']['destinations'] = [
    "127.0.0.1:#{node['graphite']['carbon']['pickle_receiver_port']}:a"
  ]
else
  if node['graphite']['chef_role']
    graphite_results = search(:node, "roles:#{node['graphite']['chef_role']} AND chef_environment:#{node.chef_environment}")
    if graphite_results
      destinations = []
      cluster_servers = []

      graphite_results.each do |result|
        destinations << "#{result['fqdn']}:#{result['graphite']['carbon']['pickle_receiver_port']}:a"
        if result['fqdn'] != node['fqdn']
          cluster_servers << "#{result['fqdn']}:#{node['graphite']['listen_port']}"
          ext_instances << "#{result['fqdn']}:a"
        else
          int_instances << "#{result['fqdn']}:a"
        end
      end

      node.default['graphite']['carbon']['relay']['destinations'] = destinations
      node.default['graphite']['graphite_web']['cluster_servers'] = cluster_servers

      node.default['graphite']['graphite_web']['carbonlink_hosts'] = [
        "#{result['fqdn']}:#{node['graphite']['carbon']['cache_query_port']}:a",
      ]
    end
  end
end

node.default['graphite']['relay_rules'] = [
  {
    'name' => 'default_rule',
    'default' => true,
    'destinations' => node['graphite']['carbon']['relay']['destinations'],
  }
]

include_recipe "graphite::default"
include_recipe "graphite::carbon_relay"


template "#{node['graphite']['base_dir']}/bin/whisper-clean-this-node.sh" do
  source 'whisper-clean-this-node.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(:graphite_lib_dir => "#{node['graphite']['base_dir']}/lib",
            :whisper_clean_py => "#{node['graphite']['base_dir']}/bin/whisper-clean.py",
            :int_instances => int_instances,
            :ext_instances => ext_instances)
  only_if { int_instances.length > 0 and ext_instances.length > 0 }
end

