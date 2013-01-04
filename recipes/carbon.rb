package "python-twisted"
package "python-simplejson"

version = node['graphite']['version']
pyver = node['graphite']['python_version']

remote_file "/usr/src/carbon-#{version}.tar.gz" do
  source node['graphite']['carbon']['uri']
  checksum node['graphite']['carbon']['checksum']
end

execute "untar carbon" do
  command "tar xzf carbon-#{version}.tar.gz"
  creates "/usr/src/carbon-#{version}"
  cwd "/usr/src"
end

execute "install carbon" do
  command "python setup.py install --prefix #{node['graphite']['base_dir']} --install-lib #{node['graphite']['base_dir']}/lib"
  creates "#{node['graphite']['base_dir']}/lib/carbon-#{version}-py#{pyver}.egg-info"
  cwd "/usr/src/carbon-#{version}"
end

template "#{node['graphite']['base_dir']}/conf/carbon.conf" do
  owner node['apache']['user']
  group node['apache']['group']
  variables( :carbon => node['graphite']['carbon'].to_hash,
             :line_receiver_interface => node['graphite']['carbon']['line_receiver_interface'],
             :pickle_receiver_interface => node['graphite']['carbon']['pickle_receiver_interface'],
             :storage_dir => node['graphite']['storage_dir'],
             :time_zone => node['graphite']['time_zone'],
             :cache_query_interface => node['graphite']['carbon']['cache_query_interface'] )
  notifies :restart, "service[carbon-cache]"
end

template "#{node['graphite']['base_dir']}/conf/storage-schemas.conf" do
  owner node['apache']['user']
  group node['apache']['group']
end

execute "carbon: change graphite storage permissions to apache user" do
  command "chown -R www-data:www-data #{node['graphite']['storage_dir']}"
  only_if do
    f = File.stat(node['graphite']['storage_dir'])
    f.uid == 0 and f.gid == 0
  end
end

directory "#{node['graphite']['base_dir']}/lib/twisted/plugins/" do
  owner node['apache']['user']
  group node['apache']['group']
end

service_type = node['graphite']['carbon']['service_type']
include_recipe "#{cookbook_name}::#{recipe_name}_#{service_type}"
