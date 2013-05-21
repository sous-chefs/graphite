#
# Cookbook Name:: graphite
# Attributes:: carbon_relay
#

default['graphite']['relay_rules'] = []

default['graphite']['carbon']['relay']['line_receiver_interface'] = "0.0.0.0"
default['graphite']['carbon']['relay']['line_receiver_port'] = 2013
default['graphite']['carbon']['relay']['pickle_receiver_interface'] = "0.0.0.0"
default['graphite']['carbon']['relay']['pickle_receiver_port'] = 2014
default['graphite']['carbon']['relay']['method'] = "rules" # rules | consistent-hashing
default['graphite']['carbon']['relay']['replication_factor'] = 1
default['graphite']['carbon']['relay']['destinations'] = []
default['graphite']['carbon']['relay']['max_datapoints_per_message'] = 500
default['graphite']['carbon']['relay']['max_queue_size'] = 10000
default['graphite']['carbon']['relay']['use_flow_control'] = "True"

