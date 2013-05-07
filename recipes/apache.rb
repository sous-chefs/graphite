include_recipe "apache2"
include_recipe "apache2::mod_python"
include_recipe "apache2::mod_headers"
if node['graphite']['ssl']['enabled']
  include_recipe "apache2::mod_ssl"
end

if node['graphite']['apache']['basic_auth']
  execute "create apache basic_auth file for graphite" do
    command "htpasswd -bc #{node['graphite']['apache']['basic_auth']['file_path']} #{node['graphite']['apache']['basic_auth']['user']} #{node['graphite']['apache']['basic_auth']['pass']}"
  end
end

template "#{node['apache']['dir']}/sites-available/graphite" do
  source "graphite-vhost.conf.erb"
end

apache_site "graphite"

apache_site "000-default" do
  enable false
end
