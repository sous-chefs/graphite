default['graphite']['version'] = "0.9.9"
default['graphite']['python_version'] = "2.6"

default['graphite']['carbon']['uri'] = "http://launchpadlibrarian.net/82112362/carbon-#{node['graphite']['version']}.tar.gz"
default['graphite']['carbon']['checksum'] = "b3d42e3b93c09"

default['graphite']['whisper']['uri'] = "http://launchpadlibrarian.net/82112367/whisper-#{node['graphite']['version']}.tar.gz"
default['graphite']['whisper']['checksum'] = "66c05eafe8d86"

default['graphite']['graphite_web']['uri'] = "http://launchpadlibrarian.net/82112308/graphite-web-#{node['graphite']['version']}.tar.gz"
default['graphite']['graphite_web']['checksum'] = "cc78bab7fb26b"

ip_address = "127.0.0.1"
carbon_interface = node['graphite']['carbon']['interface']
if carbon_interface
  ip_address = node['network']["ipaddress_#{carbon_interface}"]
end

default['graphite']['carbon']['line_receiver_interface'] = ip_address
default['graphite']['carbon']['pickle_receiver_interface'] = ip_address
default['graphite']['carbon']['cache_query_interface'] = ip_address
default['graphite']['carbon']['service_type'] = "runit"

default['graphite']['password'] = "change_me"
default['graphite']['url'] = "graphite"
default['graphite']['url_aliases'] = []
default['graphite']['listen_port'] = "80"
default['graphite']['base_dir'] = "/opt/graphite"
default['graphite']['doc_root'] = "/opt/graphite/webapp"
