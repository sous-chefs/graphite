# graphite_service

Manages a systemd carbon service instance.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates the systemd unit |
| `:enable` | Enables the service |
| `:start` | Starts the service |
| `:stop` | Stops the service |
| `:disable` | Disables the service |
| `:restart` | Restarts the service |
| `:reload` | Reloads the service |
| `:delete` | Stops, disables, and deletes the unit |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `service` | String | name property | Carbon service name, such as `cache` or `cache:a` |
| `user` | String | `'graphite'` | Service user |
| `group` | String | `'graphite'` | Service group |
| `base_dir` | String | `'/opt/graphite'` | Config directory root |
| `storage_dir` | String | `'/opt/graphite/storage'` | PID/storage directory |
| `debug` | true, false | `false` | Run with debug flag |
| `limit_nofile` | Integer | `1024` | Systemd file descriptor limit |
| `bin_dir` | String | `'/usr/bin'` | Directory containing carbon executables |

## Examples

```ruby
graphite_service 'cache'

graphite_service 'cache:a' do
  action %i(create enable start)
end
```
