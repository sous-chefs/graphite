#
# Cookbook Name:: graphite
# Attributes:: carbon_cache
#

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

default['graphite']['storage_schemas'] = [
  {
    'name' => 'catchall', 
    'pattern' => '^.*', 
    'retentions' => '60:100800,900:63000'
  }
]

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

