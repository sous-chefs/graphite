# Graphite Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/graphite.svg)](https://supermarket.chef.io/cookbooks/graphite)
[![Build Status](https://img.shields.io/circleci/project/graphite/sous-chefs/apache2/master.svg)](https://circleci.com/gh/sous-chefs/graphite)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

## Description

Library cookbook for installation and configuration of [Graphite](http://graphite.readthedocs.org) via Chef

Consult the Graphite documentation for more information:

- <http://graphite.readthedocs.io/en/latest/>
- <https://github.com/graphite-project>

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- Ubuntu 18.04+
- Debian 8+
- RHEL 7+

### Chef

- Chef 13+

### Cookbooks

- poise-python

## Attributes

See [default attributes](https://github.com/sous-chefs/graphite/blob/master/attributes/default.rb#L48) for platform specific packages installed.

- `node['graphite']['version']` - package version to install, defaults to '0.9.12'
- `node['graphite']['twisted_version']` - twisted version to pin to, defaults to '13.1'
- `node['graphite']['django_version']` - django version to use, defaults to '1.5.5'
- `node['graphite']['user']` - graphite user, 'graphite'
- `node['graphite']['group']` - graphite group, 'graphite'
- `node['graphite']['base_dir']` - default base dir, '/opt/graphite'
- `node['graphite']['doc_root']` - doc root for graphite-web, '/opt/graphite/webapp'
- `node['graphite']['storage_dir']` - storage dir, '/opt/graphite/storage'
- `node['graphite']['install_type']` - 'package' or 'source'. Setting this to source will use latest github master branch
- `default['graphite']['package_names']` - package name hash, indexed by 'install_type' attribute.
- `default['graphite']['graph_templates']` - graphite template config hash
- `default['graphite']['sort_storage_schemas']` - Boolean attribute to specify whether or not storage schemas should be sorted in alphabetical order
- `default['graphite']['sort_configs']` - Boolean attribute to specify whether or not config stanzas should be sorted in alphabetical order

### Adjusting package source location

You can override the `node['graphite']['package_names'][#{name}]['source']` attribute, where `#{name}` is one of `whisper`, `carbon` or `graphite_web`, to set a custom install path. By default a source install will use the github master branch.

## Recipes

### default

No-op, assuming cookbook inclusion in a custom wrapper.

### packages

Just install all packages, carbon and web

### carbon

Install all carbon packages, setup the graphite user, storage paths and write the carbon configuration. Does not start any services.

### web

Set up just about everything for graphite web, except configure it and start the service. Use the `graphite_web_config` resource and the `uwsgi` recipe for those two things.

Some of this weirdness may not really be needed, so send us a PR if you fix it before us. For example, I'd love some way to remove that execute block for selinux and there's probably a better way to manage all those files and directories.

### uwsgi

Start a uwsgi runit service for graphite-web. That's it.

### Various internal recipes

View the code for additional stub recipes that perform smaller pieces of functionality such as setup the user or install specific packages, the all begin with an underscore `_`.

It's like a treasure hunt.

## Resources

### Carbon daemons

Management for the various [Carbon](https://github.com/graphite-project/carbon) services which receive your metrics and write them to disk.

- `graphite_service`: sets up a carbon service with runit, essentially a glorified `runit_service`. Carbon configuration should be defined first with one of the `graphite_carbon_*` resources. Multiple daemons can be run by using multiple resources with names such as `cache:a`, `cache:b`, etc..
- `graphite_carbon_aggregator`: data driven resource for carbon-aggregator configuration
- `graphite_carbon_cache`: data driven resource for carbon-cache configuration
- `graphite_carbon_relay`: data driven resource for carbon-cache configuration

### Storage

[Whisper](https://github.com/graphite-project/whisper) is pretty much a requirement right now, so these resources assume whisper libraries should be installed. Feel free to implement something else in your own wrapper if you live on the edge and prefer [Ceres](https://github.com/graphite-project/ceres).

- `graphite_storage`: makes a directory intended for graphite storage, installs whisper
- `graphite_storage_schema`: data driven resource for storage schema

### Graphite Web

Write the configuration file for [Graphite Web](https://github.com/graphite-project/graphite-web)

- `graphite_web_config`: data driven python config file writer for graphite web. Assumes the whole file is managed, typically this is the path to local_settings.py. Custom python code can be placed in the optional 'dynamic template', by default a file named 'local_settings_dynamic.py' that is optimistically loaded if present.

Yes it's [writing python via ruby](https://github.com/sous-chefs/graphite/blob/master/libraries/chef_graphite_python.rb#L14).

A runit service definition is provided to [start a uwsgi process](https://github.com/sous-chefs/graphite/blob/master/example/graphite_example/recipes/single_node.rb#L105), but note that choice of web server for proxying to the application server is left up to you. No more hard Apache dependency!

### Accumulators

Due to the graphite config file format, the data driven resources use an accumulator pattern to find the appropriate resources in the run context and extract provided configuration data. You should never need to use these directly, but you're welcome to go crazy.

- `graphite_carbon_conf_accumulator`: lookup named carbon resources in run context and gather config
- `graphite_storage_conf_accumulator`: lookup named storage schema resources in run context and gather config

If you look at the [example cookbook recipe](https://github.com/sous-chefs/graphite/blob/master/test/fixtures/cookbooks/test/recipes/single_node.rb#L9) you probably notice that many of the resources simply take a single `config` attribute, which is basically a hash of the configuration to be written.

This can come from attributes in a wrapper cookbook or via data bags if you like. Be as creative as you can tolerate.

Accumulator pattern came from excellent work by [Mathieu Sauve-Frankel](https://github.com/kisoku/chef-accumulator)

## Usage

It's a library cookbook, intended to be used in your custom wrapper cookbook to behave as needed. It's the building materials, not the house.

We have purposefully left out web server configuration to remove the dependency, so you're free to use whatever works in your environment. This avoids the need for this cookbook to keep up to date with configuration that isn't really graphite specific.

For example usage consult the reference cookbook [example](https://github.com/sous-chefs/graphite/tree/master/test/fixtures/cookbooks/test/recipes)

## Examples

You can find example usage in the graphite_example cookbook that is included in the [git repository](https://github.com/sous-chefs/graphite/blob/master/test/fixtures/cookbooks/test/recipes/single_node.rb).

## Data Bags

Sure, use em if you like. Even encrypt them.

## Development / Contributing

- Source hosted at [GitHub][repo]
- Report issues/questions/feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested. Ideally create a topic branch for every separate change you make. For example:

1. Fork the repo
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Write some tests, see [ChefSpec](https://github.com/chefspec/chefspec)
1. Commit your awesome changes (`git commit -am 'Added some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request and tell us about it your changes.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
