# Graphite Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/graphite.svg)](https://supermarket.chef.io/cookbooks/graphite)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

## Description

Library cookbook for installing and configuring [Graphite](https://graphite.readthedocs.io/) with Chef custom resources.

This release is a full custom-resource migration. Cookbook-root recipes and attributes were removed; see [migration.md](migration.md) for the breaking-change guide and [LIMITATIONS.md](LIMITATIONS.md) for package and platform limitations.

## Requirements

### Platforms

* Debian 12+
* Ubuntu 22.04+

### Chef

* Chef Infra Client 15.3+

## Resources

* [graphite_install](documentation/graphite_install.md)
* [graphite_config](documentation/graphite_config.md)
* [graphite_carbon_cache](documentation/graphite_carbon_cache.md)
* [graphite_carbon_relay](documentation/graphite_carbon_relay.md)
* [graphite_carbon_aggregator](documentation/graphite_carbon_aggregator.md)
* [graphite_carbon_config](documentation/graphite_carbon_config.md)
* [graphite_storage](documentation/graphite_storage.md)
* [graphite_storage_schema](documentation/graphite_storage_schema.md)
* [graphite_storage_config](documentation/graphite_storage_config.md)
* [graphite_service](documentation/graphite_service.md)
* [graphite_web](documentation/graphite_web.md)
* [graphite_web_config](documentation/graphite_web_config.md)
* [graphite_uwsgi](documentation/graphite_uwsgi.md)

## Example

```ruby
graphite_install 'default'
graphite_config 'default'

graphite_carbon_cache 'default' do
  config(
    line_receiver_interface: '0.0.0.0',
    line_receiver_port: 2003,
    pickle_receiver_port: 2004,
    cache_query_port: 7002,
    local_data_dir: '/opt/graphite/storage/whisper/'
  )
end

graphite_storage_schema 'default' do
  config(pattern: '.*', retentions: '60s:1d')
end

graphite_carbon_config 'default'
graphite_storage_config 'default'
graphite_service 'cache'
```

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. Visit [sous-chefs.org](https://sous-chefs.org/) or chat in `#sous-chefs` on the Chef Community Slack.

## Development

* Source hosted at [GitHub](https://github.com/sous-chefs/graphite)
* Report issues and feature requests on [GitHub Issues](https://github.com/sous-chefs/graphite/issues)

## Contributors

This project exists thanks to all contributors.

### Backers

Thank you to all our backers.

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor.
