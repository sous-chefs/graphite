default['graphite']['uwsgi']['socket'] = '/tmp/uwsgi.sock'
default['graphite']['uwsgi']['workers'] = 8
default['graphite']['uwsgi']['carbon'] = '127.0.0.1:2003'
default['graphite']['uwsgi']['listen_http'] = false
default['graphite']['uwsgi']['service_type'] = 'runit'
default['graphite']['uwsgi']['buffer_size'] = 4096
