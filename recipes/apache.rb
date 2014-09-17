include_recipe 'apache2::mod_python'
include_recipe 'apache2::mod_headers'
include_recipe 'apache2::mod_ssl' if node['graphite']['ssl']['enabled']

execute 'create apache basic_auth file for graphite' do
  command "htpasswd -bc #{node['graphite']['apache']['basic_auth']['file_path']} #{node['graphite']['apache']['basic_auth']['user']} #{node['graphite']['apache']['basic_auth']['pass']}"
  only_if { node['graphite']['apache']['basic_auth']['enabled'] }
end

template "#{node['apache']['dir']}/sites-available/graphite.conf" do
  source 'graphite-vhost.conf.erb'
  notifies :reload, 'service[apache2]'
end

apache_site 'graphite'

apache_site '000-default' do
  enable false
end
