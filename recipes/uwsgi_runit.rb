include_recipe 'runit'

runit_service 'graphite-web' do
  default_logger true
end
