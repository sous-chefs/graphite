include_recipe 'runit'

runit_service 'graphite-web' do
  default_logger true
  subscribes :restart, 'file[uwsgi-config]'
end
