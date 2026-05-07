# graphite_web

Creates Graphite web application directories, logs, and graph template configuration.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates web paths and files (default) |
| `:delete` | Removes managed web log files |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `user` | String | `'graphite'` | Owner |
| `group` | String | `'graphite'` | Group |
| `base_dir` | String | `'/opt/graphite'` | Graphite base directory |
| `storage_dir` | String | `'/opt/graphite/storage'` | Graphite storage directory |
| `doc_root` | String | `'/opt/graphite/webapp'` | Graphite web root |
| `manage_selinux_context` | true, false | `true` | Manage web log SELinux context when enabled |
| `graph_templates` | Array | Default template set | Graph template definitions |

## Examples

```ruby
graphite_web 'default'
```
