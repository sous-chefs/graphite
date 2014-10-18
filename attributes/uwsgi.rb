default['graphite']['uwsgi']['socket'] = '/tmp/uwsgi.sock'
default['graphite']['uwsgi']['socket_permissions'] = '755'
default['graphite']['uwsgi']['workers'] = 8
default['graphite']['uwsgi']['carbon'] = '127.0.0.1:2003'
default['graphite']['uwsgi']['listen_http'] = false
default['graphite']['uwsgi']['service_type'] = 'runit'
