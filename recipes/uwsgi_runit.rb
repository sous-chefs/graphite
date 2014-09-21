include_recipe 'runit'

runit_service 'graphite-web' do
  # uwsgi/graphite-web can sometimes be a tad slow to startup, so allow more
  # than the default 7 seconds for it load up.
  default_logger true
  sv_timeout 60
end
