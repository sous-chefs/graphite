# graphite_web_config

Writes Graphite web Python settings.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Writes the settings file (default) |
| `:delete` | Removes the settings file |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `path` | String | name property | Settings file path |
| `config` | Hash | `{}` | Python settings |
| `dynamic_template` | String | `'local_settings_dynamic.py'` | Optional import file |

## Examples

```ruby
graphite_web_config '/opt/graphite/webapp/graphite/local_settings.py' do
  config(secret_key: 'secret', time_zone: 'UTC')
end
```
