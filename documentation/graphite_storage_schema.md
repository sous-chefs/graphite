# graphite_storage_schema

Declares a storage schema section for `graphite_storage_config`.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Declares schema data (default) |
| `:delete` | Removes the declaration from the run |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `config` | Hash | `{}` | Storage schema settings |

## Examples

```ruby
graphite_storage_schema 'default' do
  config(pattern: '.*', retentions: '60s:1d')
end
```
