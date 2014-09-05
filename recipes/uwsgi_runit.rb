include_recipe 'runit'

runit_service 'graphite-web' do
  default_logger true
  sv_timeout 30
end
