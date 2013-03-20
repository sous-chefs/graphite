#
# Cookbook Name:: graphite
# Attributes:: graphite
#

default['graphite']['version'] = "0.9.10"
default['graphite']['password'] = "change_me"
default['graphite']['chef_role'] = "graphite"
default['graphite']['url'] = "graphite"
default['graphite']['url_aliases'] = []
default['graphite']['listen_port'] = 80
default['graphite']['base_dir'] = "/opt/graphite"
default['graphite']['doc_root'] = "/opt/graphite/webapp"
default['graphite']['storage_dir'] = "/opt/graphite/storage"
default['graphite']['timezone'] = "America/Los_Angeles"
default['graphite']['django_root'] = "@DJANGO_ROOT@"

default['graphite']['whisper']['uri'] = "https://launchpad.net/graphite/0.9/#{node['graphite']['version']}/+download/whisper-#{node['graphite']['version']}.tar.gz"
default['graphite']['whisper']['checksum'] = "36b5fa917526224678da0a530a6f276d00074f0aa98acd6e2412c79521f9c4ff"

default['graphite']['carbon']['uri'] = "https://launchpad.net/graphite/0.9/#{node['graphite']['version']}/+download/carbon-#{node['graphite']['version']}.tar.gz"
default['graphite']['carbon']['checksum'] = "4f37e00595b5b078edb9b3f5cae318f752f4446a82623ea4da97dd7d0f6a5072"

default['graphite']['storage_schemas'] = {}
default['graphite']['storage_aggregation'] = {}
default['graphite']['relay_rules'] = {}

# carbon-cache.py
default['graphite']['carbon']['line_receiver_interface'] =   "0.0.0.0"
default['graphite']['carbon']['line_receiver_port'] = 2003
default['graphite']['carbon']['enable_udp_listener'] = "False"
default['graphite']['carbon']['udp_receiver_interface'] = "0.0.0.0"
default['graphite']['carbon']['udp_receiver_port'] = 2003
default['graphite']['carbon']['pickle_receiver_interface'] = "0.0.0.0"
default['graphite']['carbon']['pickle_receiver_port'] = 2004
default['graphite']['carbon']['use_insecure_unpickler'] = "False"
default['graphite']['carbon']['cache_query_interface'] =     "0.0.0.0"
default['graphite']['carbon']['cache_query_port'] = 7002
default['graphite']['carbon']['use_flow_control'] = "True"
default['graphite']['carbon']['max_cache_size'] = "inf"
default['graphite']['carbon']['max_creates_per_second'] = "inf"
default['graphite']['carbon']['max_updates_per_second'] = "1000"
default['graphite']['carbon']['log_whisper_updates'] = "False"
default['graphite']['carbon']['whisper_autoflush'] = "False"

case node['platform_family']
when "debian"
  default['graphite']['carbon']['service_type'] = "runit"
when "rhel","fedora"
  default['graphite']['carbon']['service_type'] = "init"
end

# Default carbon AMQP settings match the carbon default config
default['graphite']['carbon']['enable_amqp'] = false
default['graphite']['carbon']['amqp_host'] = "localhost"
default['graphite']['carbon']['amqp_port'] = 5672
default['graphite']['carbon']['amqp_vhost'] = "/"
default['graphite']['carbon']['amqp_user'] = "guest"
default['graphite']['carbon']['amqp_password'] = "guest"
default['graphite']['carbon']['amqp_exchange'] = "graphite"
default['graphite']['carbon']['amqp_metric_name_in_body'] = false


# carbon-relay.py
default['graphite']['carbon']['relay']['line_receiver_interface'] = "0.0.0.0"
default['graphite']['carbon']['relay']['line_receiver_port'] = 2013
default['graphite']['carbon']['relay']['pickle_receiver_interface'] = "0.0.0.0"
default['graphite']['carbon']['relay']['pickle_receiver_port'] = 2014
default['graphite']['carbon']['relay']['relay_method'] = "rules" # rules | consistent-hashing
default['graphite']['carbon']['relay']['replication_factor'] = 1
default['graphite']['carbon']['relay']['destinations'] = []
default['graphite']['carbon']['relay']['max_datapoints_per_message'] = 500
default['graphite']['carbon']['relay']['max_queue_size'] = 10000
default['graphite']['carbon']['relay']['use_flow_control'] = "True"


# carbon-aggregator.py
default['graphite']['carbon']['aggregator']['line_receiver_interface'] = "0.0.0.0"
default['graphite']['carbon']['aggregator']['line_receiver_port'] = 2023
default['graphite']['carbon']['aggregator']['pickle_receiver_interface'] = "0.0.0.0"
default['graphite']['carbon']['aggregator']['pickle_receiver_port'] = 2024
default['graphite']['carbon']['aggregator']['destinations'] = []
default['graphite']['carbon']['aggregator']['replication_factor'] = 1
default['graphite']['carbon']['aggregator']['max_queue_size'] = 10000
default['graphite']['carbon']['aggregator']['use_flow_control'] = "True"
default['graphite']['carbon']['aggregator']['max_datapoints_per_message'] = 500
default['graphite']['carbon']['aggregator']['max_aggregation_intervals'] = 5

# graphite-web
default['graphite']['graphite_web']['uri'] = "https://launchpad.net/graphite/0.9/#{node['graphite']['version']}/+download/graphite-web-#{node['graphite']['version']}.tar.gz"
default['graphite']['graphite_web']['checksum'] = "4fd1d16cac3980fddc09dbf0a72243c7ae32444903258e1b65e28428a48948be"

default['graphite']['graphite_web']['cluster_servers'] = []
default['graphite']['graphite_web']['carbonlink_hosts'] = []

default['graphite']['encrypted_data_bag']['name'] = nil
