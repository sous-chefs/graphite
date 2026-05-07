# graphite_carbon_config

Writes `carbon.conf` from declared carbon cache, relay, and aggregator resources.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Writes carbon configuration (default) |
| `:delete` | Removes the configuration file |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `user` | String | `'graphite'` | File owner |
| `group` | String | `'graphite'` | File group |
| `base_dir` | String | `'/opt/graphite'` | Graphite base directory |
| `storage_dir` | String | `'/opt/graphite/storage'` | Graphite storage directory |
| `path` | String | `base_dir/conf/carbon.conf` | Output file |
| `sort_configs` | true, false | `true` | Sort generated sections |

## Examples

```ruby
graphite_carbon_cache 'default' do
  config(line_receiver_port: 2003)
end

graphite_carbon_config 'default'
```
