package "python-twisted"
package "python-simplejson"

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

execute "carbon: change graphite storage permissions to www-data" do
  command "chown -R www-data:www-data /opt/graphite/storage"
  only_if do
    f = File.stat("/opt/graphite/storage")
    f.uid == 0 and f.gid == 0
  end
end

directory "/opt/graphite/lib/twisted/plugins/" do
  owner "www-data"
  group "www-data"
end

runit_service "carbon-cache" do
  finish_script true
end
