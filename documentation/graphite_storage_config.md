# graphite_storage_config

Writes `storage-schemas.conf` from declared `graphite_storage_schema` resources.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Writes storage schema configuration (default) |
| `:delete` | Removes the configuration file |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `user` | String | `'graphite'` | File owner |
| `group` | String | `'graphite'` | File group |
| `base_dir` | String | `'/opt/graphite'` | Graphite base directory |
| `storage_dir` | String | `'/opt/graphite/storage'` | Graphite storage directory |
| `path` | String | `base_dir/conf/storage-schemas.conf` | Output file |
| `sort_schemas` | true, false | `true` | Sort generated sections |

## Examples

```ruby
graphite_storage_schema 'default' do
  config(pattern: '.*', retentions: '60s:1d')
end

graphite_storage_config 'default'
```
