# graphite_install

Installs Graphite packages or pip/source artifacts and manages the Graphite user and base directory.

## Actions

| Action | Description |
|--------|-------------|
| `:install` | Installs Graphite (default) |
| `:remove` | Removes installed Graphite packages |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `user` | String | `'graphite'` | System user |
| `group` | String | `'graphite'` | System group |
| `base_dir` | String | `'/opt/graphite'` | Graphite base directory |
| `storage_dir` | String | `'/opt/graphite/storage'` | Graphite storage directory |
| `version` | String | `'1.1.10'` | Pip package version |
| `install_type` | Symbol | `:package` | `:package`, `:pip`, or `:source` |
| `package_names` | Hash | Graphite defaults | Pip/source package map |
| `system_packages` | Array | Platform defaults | Build/runtime packages |
| `pip_packages` | Array | `whisper`, `carbon`, `graphite_web` | Pip package keys to install |
| `platform_packages` | Hash | Platform defaults | Distro package map |
| `manage_user` | true, false | `true` | Manage system account |
| `manage_virtualenv` | true, false | `true` | Create virtualenv for pip/source installs |

## Examples

```ruby
graphite_install 'default'

graphite_install 'source' do
  install_type :source
end
```
