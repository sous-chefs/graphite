default['graphite']['uwsgi']['socket'] = '/tmp/uwsgi.sock'
default['graphite']['uwsgi']['chmod_socket'] = nil # '664' for example
default['graphite']['uwsgi']['workers'] = 8
default['graphite']['uwsgi']['carbon'] = '127.0.0.1:2003'
default['graphite']['uwsgi']['listen_http'] = false
default['graphite']['uwsgi']['port'] = 8080
default['graphite']['uwsgi']['service_type'] = 'runit'
