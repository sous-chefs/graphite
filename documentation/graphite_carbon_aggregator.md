# graphite_carbon_aggregator

Declares a carbon-aggregator section for `graphite_carbon_config`.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Declares aggregator configuration data (default) |
| `:delete` | Removes the declaration from the run |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `config` | Hash | `{}` | Carbon aggregator settings |

## Examples

```ruby
graphite_carbon_aggregator 'default' do
  config(line_receiver_port: 2023)
end
```
