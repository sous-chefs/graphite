template "/etc/init.d/carbon-cache" do
  source "carbon-cache.init.erb"
  variables(
    :dir     => node['graphite']['base_dir'],
    :user    => node['apache']['user'],
    :log_dir => node['graphite']['base_dir'] + "/log"
  )
  mode 00744
end

service "carbon-cache" do
  action [:enable, :start]
end
