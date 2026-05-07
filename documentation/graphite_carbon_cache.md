# graphite_carbon_cache

Declares a carbon-cache section for `graphite_carbon_config`.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Declares cache configuration data (default) |
| `:delete` | Removes the declaration from the run |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `backend` | String, Hash | `'whisper'` | Storage backend metadata |
| `config` | Hash | `{}` | Carbon cache settings |

## Examples

```ruby
graphite_carbon_cache 'default' do
  config(line_receiver_port: 2003)
end
```
