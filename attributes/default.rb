#
# Cookbook Name:: graphite
# Attributes:: default
#

include_attribute 'apache2'

default['graphite']['version'] = '0.9.12'
default['graphite']['twisted_version'] = '11.1'
default['graphite']['password'] = 'change_me'
default['graphite']['chef_role'] = 'graphite'
default['graphite']['url'] = 'graphite'
default['graphite']['url_aliases'] = []
default['graphite']['listen_port'] = 80
default['graphite']['base_dir'] = '/opt/graphite'
default['graphite']['doc_root'] = '/opt/graphite/webapp'
default['graphite']['storage_dir'] = '/opt/graphite/storage'
default['graphite']['timezone'] = 'America/Los_Angeles'
default['graphite']['django_root'] = '@DJANGO_ROOT@'
default['graphite']['encrypted_data_bag']['name'] = nil
default['graphite']['install_type'] = 'package'
default['graphite']['package_names'] = {
  'whisper' => {
    'package' => 'whisper',
    'source' => 'https://github.com/graphite-project/whisper/zipball/master'
  },
  'carbon' => {
    'package' => 'carbon',
    'source' => 'https://github.com/graphite-project/graphite-web/zipball/master'
  },
  'graphite_web' => {
    'package' => 'graphite-web',
    'source' => 'https://github.com/graphite-project/graphite-web/zipball/master'
  }
}

#
# graphite_web
#
default['graphite']['web']['django_cache'] = true
default['graphite']['web']['debug'] = 'False'
default['graphite']['web']['bitmap_support'] = true
default['graphite']['web']['admin_email'] = 'admin@org.com'
default['graphite']['web']['cluster_servers'] = []
default['graphite']['web']['carbonlink_hosts'] = []
default['graphite']['web']['memcached_hosts'] = ['127.0.0.1:11211']
default['graphite']['web']['database']['NAME'] = node['graphite']['storage_dir'] + '/graphite.db'
default['graphite']['web']['database']['ENGINE'] = 'django.db.backends.sqlite3'
default['graphite']['web']['database']['USER'] = ''
default['graphite']['web']['database']['PASSWORD'] = ''
default['graphite']['web']['database']['HOST'] = ''
default['graphite']['web']['database']['PORT'] = ''
default['graphite']['web']['ldap']['SERVER'] = ''
default['graphite']['web']['ldap']['BASE_USER'] = ''
default['graphite']['web']['ldap']['BASE_PASS'] = ''
default['graphite']['web']['ldap']['USER_QUERY'] = '(sAMAccountName=%s)'
default['graphite']['web']['ldap']['SEARCH_BASE'] = ''
default['graphite']['web']['auth']['REMOTE_USER_AUTH'] = false
default['graphite']['web']['auth']['LOGIN_URL'] = '/account/login'
default['graphite']['web']['email']['BACKEND'] = 'django.core.mail.backends.smtp.EmailBackend'
default['graphite']['web']['email']['HOST'] = 'localhost'
default['graphite']['web']['email']['PORT'] = '25'
default['graphite']['web']['email']['HOST_USER'] = ''
default['graphite']['web']['email']['HOST_PASSWORD'] = ''
default['graphite']['web']['email']['USE_TLS'] = false
default['graphite']['web_server'] = 'apache'
default['graphite']['create_user'] = false

default['graphite']['graph_templates'] = [
  {
    'name' => 'default',
    'background' => 'black',
    'foreground' => 'white',
    'majorLine' => 'white',
    'minorLine' => 'grey',
    'lineColors' => 'blue,green,red,purple,brown,yellow,aqua,grey,magenta,pink,gold,rose',
    'fontName' => 'Sans',
    'fontSize' => '10',
    'fontBold' => 'False',
    'fontItalic' => 'False'
  }
]

case node['graphite']['web_server']
when 'apache'
  default['graphite']['user_account'] = node['apache']['user']
  default['graphite']['group_account'] = node['apache']['group']
when 'uwsgi'
  default['graphite']['user_account'] = 'graphite'
  default['graphite']['group_account'] = 'graphite'
end

default['graphite']['ssl']['enabled'] = false
default['graphite']['ssl']['cipher_suite'] = 'ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP'
default['graphite']['ssl']['certificate_file'] = '/etc/ssl/server.crt'
default['graphite']['ssl']['certificate_key_file'] = '/etc/ssl/server.key'

default['graphite']['apache']['basic_auth']['enabled'] = false
default['graphite']['apache']['basic_auth']['file_path'] = "#{node['graphite']['doc_root']}/htpasswd"
default['graphite']['apache']['basic_auth']['user'] = nil
default['graphite']['apache']['basic_auth']['pass'] = nil
