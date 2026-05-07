# graphite_config

Creates shared Graphite directories and `graphTemplates.conf`.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates directories and templates (default) |
| `:delete` | Removes managed directories and template |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `user` | String | `'graphite'` | Owner |
| `group` | String | `'graphite'` | Group |
| `base_dir` | String | `'/opt/graphite'` | Graphite base directory |
| `storage_dir` | String | `'/opt/graphite/storage'` | Graphite storage directory |
| `graph_templates` | Array | Default template set | Graph template definitions |

## Examples

```ruby
graphite_config 'default'
```
