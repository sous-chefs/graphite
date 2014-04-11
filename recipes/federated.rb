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

int_instances = []
ext_instances = []

if Chef::Config[:solo]
  destinations = []
  node['graphite']['carbon']['caches'].each do |instance|
    destinations << "127.0.0.1:#{instance.last['pickle_receiver_port']}:#{instance.first}"
  end
  node.default['graphite']['carbon']['relay']['destinations'] = destinations
else
  if node['graphite']['chef_role']
    graphite_results = search(:node, "role:#{node['graphite']['chef_role']} AND chef_environment:#{node.chef_environment} AND region:#{node.region}").sort
    if graphite_results
      destinations = []
      carbonlink_hosts = []
      cluster_servers = []
      replication_relay = []

      graphite_results.each do |result|
        result['graphite']['carbon']['caches'].each do |instance|
          if result['fqdn'] == node['fqdn']
          destinations << "#{result['fqdn']}:#{instance.last['pickle_receiver_port']}:#{instance.first}"
          end
          if result['fqdn'] != node['fqdn']
            cluster_servers << "#{result['fqdn']}:#{node['graphite']['listen_port']}" unless cluster_servers.include?("#{result['fqdn']}:#{node['graphite']['listen_port']}")
            ext_instances << "#{result['fqdn']}:#{instance}"
          else
            carbonlink_hosts << "#{result['fqdn']}:#{instance.last['cache_query_port']}:#{instance.first}"
            int_instances << "#{result['fqdn']}:#{instance}"
          end
        end
        result['graphite']['carbon']['relays'].each do |instance|
        if instance.first != "a" 
          replication_relay << "#{result['fqdn']}:#{instance.last['pickle_receiver_port']}:#{instance.first}" 
        end
      end
      end
      node.default['graphite']['carbon']['relay']['primary_relay'] = replication_relay
      node.default['graphite']['carbon']['relay']['destinations'] = destinations
      node.default['graphite']['web']['carbonlink_hosts'] = carbonlink_hosts
      node.default['graphite']['web']['cluster_servers'] = cluster_servers
    end
  end
end

node.default['graphite']['relay_rules'] = [
  {
    'name' => 'default_rule',
    'default' => true,
    'destinations' => node['graphite']['carbon']['relay']['destinations']
  }
]

include_recipe 'graphite::default'
include_recipe 'graphite::carbon_relay'

template "#{node['graphite']['base_dir']}/bin/whisper-clean-this-node.sh" do
  source 'whisper-clean-this-node.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables(:graphite_lib_dir => "#{node['graphite']['base_dir']}/lib",
            :whisper_clean_py => "#{node['graphite']['base_dir']}/bin/whisper-clean.py",
            :int_instances => int_instances,
            :ext_instances => ext_instances)
  only_if { int_instances.length > 0 && ext_instances.length > 0 }
end
