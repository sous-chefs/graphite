package "python-twisted"

version = node[:graphite][:version]

remote_file "/usr/src/carbon-#{version}.tar.gz" do
  source node[:graphite][:carbon][:uri]
  checksum node[:graphite][:carbon][:checksum]
end

execute "untar carbon" do
  command "tar xzf carbon-#{version}.tar.gz"
  creates "/usr/src/carbon-#{version}"
  cwd "/usr/src"
end

execute "install carbon" do
  command "python setup.py install"
  creates "/opt/graphite/lib/carbon-#{version}-py2.6.egg-info"
  cwd "/usr/src/carbon-#{version}"
end

template "/opt/graphite/conf/carbon.conf" do
  owner "www-data"
  group "www-data"
  variables( :line_receiver_interface => node[:graphite][:carbon][:line_receiver_interface],
             :pickle_receiver_interface => node[:graphite][:carbon][:pickle_receiver_interface],
             :cache_query_interface => node[:graphite][:carbon][:cache_query_interface] )
  notifies :restart, "service[carbon-cache]"
end

template "/opt/graphite/conf/storage-schemas.conf" do
  owner "www-data"
  group "www-data"
end

template "/etc/init/carbon-cache.conf" do
  source "carbon-cache.conf.erb"
  owner "www-data"
  group "www-data"
  notifies :restart, "service[carbon-cache]"
end

directory "/opt/graphite/lib/twisted/plugins/" do
  owner "www-data"
  group "www-data"
end

service "carbon-cache" do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
