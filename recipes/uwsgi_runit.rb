include_recipe 'runit'

runit_service 'graphite-web' do
  # Sometimes graphite-web starts, but runit fails to understand that it started,
  # so timeout the startup after 10 seconds but try to start it at least 10 times.
  sv_timeout 10
  retries 10
  retry_delay 2
  default_logger true
  restart_on_update false
end
