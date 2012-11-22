default['graphite']['version'] = "0.9.10"
default['graphite']['python_version'] = "2.7"

default['graphite']['carbon']['uri'] = "https://github.com/downloads/graphite-project/carbon/carbon-0.9.10.tar.gz"
default['graphite']['carbon']['checksum'] = "4f37e00595b5b078edb9b3f5cae318f752f4446a82623ea4da97dd7d0f6a5072"

default['graphite']['whisper']['uri'] = "https://github.com/downloads/graphite-project/whisper/whisper-0.9.10.tar.gz"
default['graphite']['whisper']['checksum'] = "36b5fa917526224678da0a530a6f276d00074f0aa98acd6e2412c79521f9c4ff"

default['graphite']['graphite_web']['uri'] = "https://github.com/downloads/graphite-project/graphite-web/graphite-web-0.9.10.tar.gz"
default['graphite']['graphite_web']['checksum'] = "4fd1d16cac3980fddc09dbf0a72243c7ae32444903258e1b65e28428a48948be"

default['graphite']['carbon']['line_receiver_interface'] =   "127.0.0.1"
default['graphite']['carbon']['pickle_receiver_interface'] = "127.0.0.1"
default['graphite']['carbon']['cache_query_interface'] =     "127.0.0.1"
default['graphite']['carbon']['service_type'] = "runit"
default['graphite']['carbon']['log_updates'] = false

default['graphite']['storage_schemas']['catchall'] = {
  "priority"    => 0,
  "pattern"     => "^.*",
  "retentions"  => "60:100800,900:63000"
}

default['graphite']['password'] = "change_me"
default['graphite']['url'] = "graphite"
default['graphite']['url_aliases'] = []
default['graphite']['listen_address'] = "*"
default['graphite']['listen_port'] = "80"
default['graphite']['base_dir'] = "/opt/graphite"
default['graphite']['doc_root'] = "/opt/graphite/webapp"

default['graphite']['basic_authentication']['enabled'] = false
default['graphite']['basic_authentication']['auth_name'] = "Authentication required"
default['graphite']['basic_authentication']['htpasswd_location'] = "#{node['graphite']['doc_root']}/.htpasswd"