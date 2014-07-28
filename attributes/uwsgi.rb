default['graphite']['uwsgi']['service_type'] = 'runit'

default['graphite']['uwsgi']['config']['processes'] = 8
default['graphite']['uwsgi']['config']['plugins'] = ['carbon']
default['graphite']['uwsgi']['config']['carbon'] = '127.0.0.1:2003'
default['graphite']['uwsgi']['config']['http'] = nil
default['graphite']['uwsgi']['config']['socket'] = '/tmp/uwsgi.sock'
default['graphite']['uwsgi']['config']['pythonpath'] = ["#{node['graphite']['base_dir']}/lib", "#{node['graphite']['base_dir']}/webapp/graphite"]
default['graphite']['uwsgi']['config']['wsgi-file'] = "#{node['graphite']['base_dir']}/conf/graphite.wsgi.example"
default['graphite']['uwsgi']['config']['uid'] = node['graphite']['user_account']
default['graphite']['uwsgi']['config']['gid'] = node['graphite']['group_account']
default['graphite']['uwsgi']['config']['procname'] = 'graphite-web'
default['graphite']['uwsgi']['config']['no-orphans'] = true
default['graphite']['uwsgi']['config']['master'] = true
default['graphite']['uwsgi']['config']['die-on-term'] = true
