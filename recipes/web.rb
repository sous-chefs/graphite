include_recipe "apache2::mod_python"

package "python-cairo-dev"
package "python-django"
package "python-django-tagging"
package "python-memcache"
package "python-rrdtool"

remote_file "/usr/src/graphite-web-#{node.graphite.version}.tar.gz" do
  source node.graphite.graphite_web.uri
  checksum node.graphite.graphite_web.checksum
end

execute "untar graphite-web" do
  command "tar xzf graphite-web-#{node.graphite.version}.tar.gz"
  creates "/usr/src/graphite-web-#{node.graphite.version}"
  cwd "/usr/src"
end

execute "install graphite-web" do
  command "python setup.py install"
  creates "/opt/graphite/webapp/graphite_web-#{node.graphite.version}-py2.6.egg-info"
  cwd "/usr/src/graphite-web-#{node.graphite.version}"
end

template "/etc/apache2/sites-available/graphite" do
  source "graphite-vhost.conf.erb"
end

apache_site "000-default" do
  enable false
end

apache_site "graphite"

directory "/opt/graphite/storage/log/webapp" do
  owner "www-data"
  group "www-data"
end

directory "/opt/graphite/storage" do
  owner "www-data"
  group "www-data"
end

cookbook_file "/opt/graphite/storage/graphite.db" do
  owner "www-data"
  group "www-data"
  action :create_if_missing
end
