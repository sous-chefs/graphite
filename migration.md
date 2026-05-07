# Migration

## Breaking Change

This cookbook no longer ships cookbook-root recipes or node attributes. Wrapper cookbooks must declare Graphite resources directly and pass configuration through resource properties.

## Recipe Mapping

| Previous recipe | Replacement |
|-----------------|-------------|
| `graphite::carbon` | `graphite_install`, `graphite_config`, `graphite_carbon_*`, `graphite_carbon_config`, `graphite_storage_config`, `graphite_service` |
| `graphite::web` | `graphite_install`, `graphite_config`, `graphite_web`, `graphite_web_config` |
| `graphite::uwsgi` | `graphite_uwsgi` |
| `graphite::packages` | `graphite_install` |

## Attribute Mapping

| Previous attribute | Replacement property |
|--------------------|----------------------|
| `node['graphite']['version']` | `graphite_install.version` |
| `node['graphite']['user']` | `user` on install/config/service resources |
| `node['graphite']['group']` | `group` on install/config/service resources |
| `node['graphite']['base_dir']` | `base_dir` on install/config/service resources |
| `node['graphite']['storage_dir']` | `storage_dir` on install/config/service resources |
| `node['graphite']['install_type']` | `graphite_install.install_type` |
| `node['graphite']['package_names']` | `graphite_install.package_names` |
| `node['graphite']['system_packages']` | `graphite_install.system_packages` |
| `node['graphite']['graph_templates']` | `graphite_config.graph_templates` or `graphite_web.graph_templates` |
| `node['graphite']['sort_configs']` | `graphite_carbon_config.sort_configs` |
| `node['graphite']['sort_storage_schemas']` | `graphite_storage_config.sort_schemas` |
| `node['graphite']['uwsgi']` values | matching `graphite_uwsgi` properties |

## Example

```ruby
graphite_install 'default'
graphite_config 'default'

graphite_carbon_cache 'default' do
  config(line_receiver_port: 2003, pickle_receiver_port: 2004)
end

graphite_storage_schema 'default' do
  config(pattern: '.*', retentions: '60s:1d')
end

graphite_carbon_config 'default'
graphite_storage_config 'default'
graphite_service 'cache'
```
