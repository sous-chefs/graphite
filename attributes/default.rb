#
# Cookbook Name:: graphite
# Attributes:: default
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

default['graphite']['encrypted_data_bag']['name'] = nil

default['graphite']['graphite_web']['bitmap_support'] = true


#
# graphite_web
#

default['graphite']['web']['uri'] = "https://launchpad.net/graphite/0.9/#{node['graphite']['version']}/+download/graphite-web-#{node['graphite']['version']}.tar.gz"
default['graphite']['web']['checksum'] = "4fd1d16cac3980fddc09dbf0a72243c7ae32444903258e1b65e28428a48948be"
default['graphite']['web']['debug'] = "False"
default['graphite']['web']['admin_email'] = "admin@org.com"
default['graphite']['web']['cluster_servers'] = []
default['graphite']['web']['carbonlink_hosts'] = []

default['graphite']['web_server'] = 'apache'
default['graphite']['user_account'] = node['apache']['user']
default['graphite']['group_account'] = node['apache']['group']
default['graphite']['create_user'] = false

default['graphite']['ssl']['enabled'] = false
default['graphite']['ssl']['cipher_suite'] = "ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP"
default['graphite']['ssl']['certificate_file'] = "/etc/ssl/server.crt"
default['graphite']['ssl']['certificate_key_file'] = "/etc/ssl/server.key"

default['graphite']['apache']['basic_auth']['enabled'] = false
default['graphite']['apache']['basic_auth']['file_path'] = "#{node['graphite']['doc_root']}/htpasswd"
default['graphite']['apache']['basic_auth']['user'] = nil
default['graphite']['apache']['basic_auth']['pass'] = nil
