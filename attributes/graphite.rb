#
# Cookbook Name:: graphite
# Attributes:: graphite
#

default['graphite']['version'] = "0.9.10"
default['graphite']['password'] = "change_me"
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

default['graphite']['graphite_web']['uri'] = "https://launchpad.net/graphite/0.9/#{node['graphite']['version']}/+download/graphite-web-#{node['graphite']['version']}.tar.gz"
default['graphite']['graphite_web']['checksum'] = "4fd1d16cac3980fddc09dbf0a72243c7ae32444903258e1b65e28428a48948be"

default['graphite']['carbon']['uri'] = "https://launchpad.net/graphite/0.9/#{node['graphite']['version']}/+download/carbon-#{node['graphite']['version']}.tar.gz"
default['graphite']['carbon']['checksum'] = "4f37e00595b5b078edb9b3f5cae318f752f4446a82623ea4da97dd7d0f6a5072"
default['graphite']['carbon']['line_receiver_interface'] =   "0.0.0.0"
default['graphite']['carbon']['line_receiver_port'] = 2003
default['graphite']['carbon']['pickle_receiver_interface'] = "0.0.0.0"
default['graphite']['carbon']['pickle_receiver_port'] = 2004
default['graphite']['carbon']['cache_query_interface'] =     "0.0.0.0"
default['graphite']['carbon']['cache_query_port'] = 7002
default['graphite']['carbon']['max_updates_per_second'] = 1000
default['graphite']['carbon']['service_type'] = "runit"
default['graphite']['carbon']['log_whisper_updates'] = "False"

default['graphite']['encrypted_data_bag']['name'] = nil
