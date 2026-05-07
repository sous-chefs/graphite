# graphite_uwsgi

Manages the Graphite web uWSGI systemd socket and service.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates socket and service units |
| `:enable` | Enables the service |
| `:start` | Starts the service |
| `:stop` | Stops the service |
| `:disable` | Disables the service |
| `:delete` | Stops, disables, and deletes units |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `user` | String | `'graphite'` | Service user |
| `group` | String | `'graphite'` | Service group |
| `base_dir` | String | `'/opt/graphite'` | Graphite base directory |
| `storage_dir` | String | `'/opt/graphite/storage'` | Graphite storage directory |
| `socket` | String | `'/tmp/uwsgi.sock'` | uWSGI socket path |
| `socket_permissions` | String | `'755'` | Socket mode |
| `socket_user` | String | `'graphite'` | Socket user |
| `socket_group` | String | `'graphite'` | Socket group |
| `workers` | Integer | `8` | Worker count |
| `carbon` | String, nil | `'127.0.0.1:2003'` | Carbon plugin target |
| `listen_http` | true, false | `false` | Listen on HTTP port |
| `port` | Integer | `8080` | HTTP port |
| `buffer_size` | String | `'4096'` | uWSGI buffer size |
| `limit_nofile` | Integer | `1024` | Systemd file descriptor limit |

## Examples

```ruby
graphite_uwsgi 'default' do
  listen_http true
  port 8080
end
```
