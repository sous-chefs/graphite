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

if node['graphite']['chef_role']
  graphite_results = search(:node, "roles:#{node['graphite']['chef_role']} AND chef_environment:#{node.chef_environment}")
  if graphite_results
    destinations = []
    graphite_results.each do |result|
      destinations << result['fqdn']
    end

    node.default['graphite']['carbon']['relay']['destinations'] = destinations.map do |x|
      "#{x}:#{node['graphite']['carbon']['pickle_receiver_port']}:a"
    end

    cluster_servers = destinations.map do |x|
      if x != node['fqdn']
        "#{x}:#{node['graphite']['listen_port']}"
      end
    end
    node.default['graphite']['web']['cluster_servers'] = cluster_servers.compact

    node.default['graphite']['web']['carbonlink_hosts'] = [
      "127.0.0.1:#{node['graphite']['carbon']['cache_query_port']}:a",
    ]
  end
end

include_recipe "graphite::default"
include_recipe "graphite::carbon_relay"

