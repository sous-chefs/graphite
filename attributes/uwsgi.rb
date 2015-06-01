default['graphite']['uwsgi']['service_type'] = 'runit'

basedir = default['graphite']['base_dir']

default['graphite']['uwsgi']['config'] = {
    "processes" => 8,
    "plugins" => [
        "carbon --carbon 127.0.0.1:2003"
    ],
    "pythonpath" => [
        "#{basedir}/lib",
        "#{basedir}/webapp/graphite"
    ],
    "wsgi-file" => "#{basedir}/conf/graphite.wsgi.example",
    "uid" => default['graphite']['user'],
    "gid" => default['graphite']['group'],
    "no-orphans" => true,
    "master" => true,
    "die-on-term" => true,
    "socket" => "/tmp/uwsgi.sock"
}
