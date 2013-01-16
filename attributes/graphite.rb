default['graphite']['version'] = "0.9.10"
default['graphite']['python_version'] = "2.7"

default['graphite']['carbon']['uri'] = "https://launchpadlibrarian.net/106575865/carbon-#{node['graphite']['version']}.tar.gz"
default['graphite']['carbon']['checksum'] = "4f37e00595b5b"

default['graphite']['whisper']['uri'] = "https://launchpadlibrarian.net/106575859/whisper-#{node['graphite']['version']}.tar.gz"
default['graphite']['whisper']['checksum'] = "36b5fa9175262"

default['graphite']['graphite_web']['uri'] = "https://launchpadlibrarian.net/106575888/graphite-web-#{node['graphite']['version']}.tar.gz"
default['graphite']['graphite_web']['checksum'] = "4fd1d16cac398"

default['graphite']['carbon']['line_receiver_interface'] =   "127.0.0.1"
default['graphite']['carbon']['pickle_receiver_interface'] = "127.0.0.1"
default['graphite']['carbon']['cache_query_interface'] =     "127.0.0.1"
default['graphite']['carbon']['service_type'] = "runit"

default['graphite']['password'] = "change_me"
default['graphite']['host'] = "graphite"
default['graphite']['host_aliases'] = []
default['graphite']['port'] = "80"
default['graphite']['base_dir'] = "/opt/graphite"
default['graphite']['webapp_dir'] = "/opt/graphite/webapp"
