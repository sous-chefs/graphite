template '/etc/init/graphite-web.conf' do
  source 'uwsgi.upstart.erb'
  mode 00644
end

service 'graphite-web' do
  provider Chef::Provider::Service::Upstart
  supports :restart => true
  action [:enable, :start]
end
