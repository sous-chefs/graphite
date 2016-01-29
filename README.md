# Graphite Cookbook

[![Build Status](https://travis-ci.org/hw-cookbooks/graphite.svg?branch=master)](https://travis-ci.org/hw-cookbooks/graphite)
[![Code Climate](https://codeclimate.com/github/hw-cookbooks/graphite/badges/gpa.svg)](https://codeclimate.com/github/hw-cookbooks/graphite)
[![Cookbook Version](https://img.shields.io/cookbook/v/graphite.svg)](https://supermarket.chef.io/cookbooks/graphite)


## Description

Library cookbook for installation and configuration of [Graphite](http://graphite.readthedocs.org) via Chef

Consult the Graphite documentation for more information:

- http://graphite.readthedocs.org/en/latest/
- https://github.com/graphite-project


## Requirements
#### Platforms

* Ubuntu
* Debian
* RHEL and derivatives (Centos, Amazon Linux, Oracle Linux, Scientific Linux)
* Fedora

#### Chef
* Chef 11+

#### Cookbooks
* ark
* java
* windows


## Attributes
See
[default attributes](https://github.com/hw-cookbooks/graphite/blob/master/attributes/default.rb#L48)
for platform specific packages installed.

- `node['graphite']['version']` - package version to install, defaults to '0.9.12'
- `node['graphite']['twisted_version']` - twisted version to pin to,
  defaults to '13.1'
- `node['graphite']['django_version']` - django version to use,
  defaults to '1.5.5'
- `node['graphite']['user']` - graphite user, 'graphite'
- `node['graphite']['group']` - graphite group, 'graphite'
- `node['graphite']['base_dir']` - default base dir, '/opt/graphite'
- `node['graphite']['doc_root']` - doc root for graphite-web, '/opt/graphite/webapp'
- `node['graphite']['storage_dir'] ` - storage dir, '/opt/graphite/storage'
- `node['graphite']['install_type']` - 'package' or 'source'. Setting
  this to source will use latest github master branch
- `default['graphite']['package_names']` - package name hash, indexed
  by 'install_type' attribute.
- `default['graphite']['graph_templates']` - graphite template config hash

### Adjusting package source location

You can override the
`node['graphite']['package_names'][#{name}]['source']` attribute,
where `#{name}` is one of `whisper`, `carbon` or `graphite_web`, to
set a custom install path. By default a source install will use the
github master branch.


## Recipes
### default

No-op, assuming cookbook inclusion in a custom wrapper.

### packages

Just install all packages, carbon and web

### carbon

Install all carbon packages, setup the graphite user, storage paths
and write the carbon configuration. Does not start any services.

### web

Set up just about everything for graphite web, except configure it and
start the service. Use the `graphite_web_config` resource and the
`uwsgi` recipe for those two things.

Some of this weirdness may not really be needed, so send us a PR if
you fix it before us. For example, I'd love some way to remove that
execute block for selinux and there's probably a better way to manage
all those files and directories.

### uwsgi

Start a uwsgi runit service for graphite-web. That's it.

### Various internal recipes

View the code for additional stub recipes that perform smaller pieces
of functionality such as setup the user or install specific packages,
the all begin with an underscore `_`.

It's like a treasure hunt.

## Custom Resources

### Carbon daemons
Management for the various
[Carbon](https://github.com/graphite-project/carbon) services which
receive your metrics and write them to disk.

* `graphite_service`: sets up a carbon service with runit, essentially
   a glorified `runit_service`. Carbon configuration should be defined
   first with one of the `graphite_carbon_*` resources. Multiple
   daemons can be run by using multiple resources with names such as
   `cache:a`, `cache:b`, etc..
* `graphite_carbon_aggregator`: data driven resource for carbon-aggregator configuration
* `graphite_carbon_cache`: data driven resource for carbon-cache configuration
* `graphite_carbon_relay`: data driven resource for carbon-cache configuration

### Storage
[Whisper](https://github.com/graphite-project/whisper) is
pretty much a requirement right now, so these resources assume whisper
libraries should be installed. Feel free to implement something else in
your own wrapper if you live on the edge and prefer [Ceres](https://github.com/graphite-project/ceres).

* `graphite_storage`: makes a directory intended for graphite storage,
  installs whisper
* `graphite_storage_schema`: data driven resource for storage schema

### Graphite Web
Write the configuration file for [Graphite Web](https://github.com/graphite-project/graphite-web)

* `graphite_web_config`: data driven python config file writer for
   graphite web. Assumes the whole file is managed, typically this is
   the path to local_settings.py. Custom python code can be placed in
   the optional 'dynamic template', by default a file named
   'local_settings_dynamic.py' that is optimistically loaded if
   present.

Yes it's [writing python via ruby](https://github.com/hw-cookbooks/graphite/blob/master/libraries/chef_graphite_python.rb#L14).

A runit service definition is provided to [start a uwsgi process](https://github.com/hw-cookbooks/graphite/blob/master/example/graphite_example/recipes/single_node.rb#L105), but note that choice of web server for proxying to the application server is left up to you. No more hard Apache dependency!

### Accumulators
Due to the graphite config file format, the data driven resources use
an accumulator pattern to find the appropriate resources in the run
context and extract provided configuration data. You should never need
to use these directly, but you're welcome to go crazy.

* `graphite_carbon_conf_accumulator`: lookup named carbon resources in
  run context and gather config
* `graphite_storage_conf_accumulator`: lookup named storage schema
  resources in run context and gather config

If you look at the
[example cookbook recipe](https://github.com/hw-cookbooks/graphite/blob/master/example/graphite_example/recipes/single_node.rb#L6)
you probably notice that many of the resources simply take a single `config`
attribute, which is basically a hash of the configuration to be written.

This can come from attributes in a wrapper cookbook or via data bags
if you like. Be as creative as you can tolerate.

Accumulator pattern came from excellent work by [Mathieu Sauve-Frankel](https://github.com/kisoku/chef-accumulator)

## Usage

It's a library cookbook, intended to be used in your custom wrapper
cookbook to behave as needed. It's the building materials, not the
house.

We have purposefully left out web server configuration to remove the
dependency, so you're free to use whatever works in your environment.
This avoids the need for this cookbook to keep up to date with
configuration that isn't really graphite specific.

For example usage consult the reference cookbook [example](https://github.com/hw-cookbooks/graphite/tree/master/example/graphite_example/recipes)

Feel free to ask us questions anytime on irc: #heavywater on freenode

## Examples

You can find example usage in the graphite_example cookbook that is included in the [git repository](https://github.com/hw-cookbooks/graphite/blob/master/example/graphite_example/recipes/single_node.rb).

## Data Bags

Sure, use em if you like. Even encrypt them.

## Amazon Web Services

Due to the old version of Chef used on Amazon Web Services in order to
successfully run this cookbook you may need to add the
[`delayed_evaluator`](http://community.opscode.com/cookbooks/delayed_evaluator)
recipe to your run list before the `graphite` recipe.

## Development / Contributing

* Source hosted at [GitHub][repo]
* Report issues/questions/feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make. For
example:

1. Fork the repo
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write some tests, see [ChefSpec](https://github.com/sethvargo/chefspec)
4. Commit your awesome changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request and tell us about it your changes.
