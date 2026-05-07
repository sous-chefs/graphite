# graphite_carbon_relay

Declares a carbon-relay section for `graphite_carbon_config`.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Declares relay configuration data (default) |
| `:delete` | Removes the declaration from the run |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `config` | Hash | `{}` | Carbon relay settings |

## Examples

```ruby
graphite_carbon_relay 'default' do
  config(line_receiver_port: 2013)
end
```
