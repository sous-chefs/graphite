# graphite_storage

Creates a Graphite storage directory and optionally installs Whisper.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates storage path and installs backend (default) |
| `:delete` | Removes storage path and pip backend |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `path` | String | name property | Storage path |
| `user` | String | `'graphite'` | Directory owner |
| `group` | String | `'graphite'` | Directory group |
| `base_dir` | String | `'/opt/graphite'` | Virtualenv path for pip installs |
| `storage_dir` | String | `'/opt/graphite/storage'` | Shared storage root |
| `package_name` | String | `'whisper'` | Pip backend package |
| `version` | String | `nil` | Pip backend version |
| `backend_type` | String | `'whisper'` | Backend type label |
| `install_type` | Symbol | `:package` | `:package`, `:pip`, or `:source` |

## Examples

```ruby
graphite_storage '/opt/graphite/storage'
```
