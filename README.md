# Graphite Cookbook

[![Build Status](https://travis-ci.org/hw-cookbooks/graphite.png?branch=teh-futur)](https://travis-ci.org/hw-cookbooks/graphite)
[![Code Climate](https://codeclimate.com/github/hw-cookbooks/graphite.png)](https://codeclimate.com/github/hw-cookbooks/graphite)

## Description

Library cookbook for installation and configuration of Graphite
http://graphite.wikidot.com/ via Chef

Consult the Graphite documentation for more information:

- http://graphite.readthedocs.org/en/latest/
- http://graphite.wikidot.com/
- https://github.com/graphite-project

## Platforms

* Ubuntu
* Debian
* RHEL and derivatives (Centos, Amazon Linux, Oracle Linux, Scientific Linux)
* Fedora

## Usage

It's a library cookbook, intended to be used in your custom wrapper
cookbook to behave as needed. It's the building materials, not the
house.

For example usage consult the reference cookbook [example](https://github.com/hw-cookbooks/graphite/tree/master/example/graphite_example/recipes)

Feel free to ask us questions anytime on irc: #heavywater on freenode

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
