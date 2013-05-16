#
# Cookbook Name:: graphite
# Attributes:: graphite_web
#

default['graphite']['graphite_web']['uri'] = "https://launchpad.net/graphite/0.9/#{node['graphite']['version']}/+download/graphite-web-#{node['graphite']['version']}.tar.gz"
default['graphite']['graphite_web']['checksum'] = "4fd1d16cac3980fddc09dbf0a72243c7ae32444903258e1b65e28428a48948be"
default['graphite']['graphite_web']['debug'] = "False"
default['graphite']['graphite_web']['admin_email'] = "admin@org.com"

default['graphite']['web_server'] = 'apache'
default['graphite']['user_account'] = node['apache']['user']
default['graphite']['group_account'] = node['apache']['group']
default['graphite']['create_user'] = false

case node['platform_family']
when "debian"
  default['graphite']['uwsgi_packages'] = %w{uwsgi uwsgi-plugin-python uwsgi-plugin-carbon}
else
  default['graphite']['uwsgi_packages'] = []
end

default['graphite']['ssl']['enabled'] = false
default['graphite']['ssl']['cipher_suite'] = "ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP"
default['graphite']['ssl']['certificate_file'] = "/etc/ssl/server.crt"
default['graphite']['ssl']['certificate_key_file'] = "/etc/ssl/server.key"

default['graphite']['apache']['basic_auth']['enabled'] = false
default['graphite']['apache']['basic_auth']['file_path'] = "#{node['graphite']['doc_root']}/htpasswd"
default['graphite']['apache']['basic_auth']['user'] = nil
default['graphite']['apache']['basic_auth']['pass'] = nil
