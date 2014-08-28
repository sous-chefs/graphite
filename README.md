# Graphite Cookbook

[![Build Status](https://travis-ci.org/hw-cookbooks/graphite.png?branch=teh-futur)](https://travis-ci.org/hw-cookbooks/graphite)
[![Code Climate](https://codeclimate.com/github/hw-cookbooks/graphite.png)](https://codeclimate.com/github/hw-cookbooks/graphite)
[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/6114f7435c3584dc13b072c8bdb80fa5 "githalytics.com")](http://githalytics.com/hw-cookbooks/graphite)

## Description

Library cookbook for installation and configuration of Graphite
http://graphite.wikidot.com/ via Chef

Consult the Graphite documentation for more information:

- http://graphite.readthedocs.org/en/latest/
- http://graphite.wikidot.com/

## Platforms

* Ubuntu 10.04 / Ubuntu 12.04
* Debian
* RHEL and derivatives (Centos, Amazon Linux, Oracle Linux, Scientific Linux)
* Fedora

## Data Bags

TODO (sure, use em if you like, even encrypt them)

## Usage

It's a library cookbook, intended to be used in your custom wrapper
cookbook to behave as needed. It's the building materials, not the
house.

For example usage consult the reference cookbook [example](https://github.com/hw-cookbooks/graphite/tree/master/example/graphite_example/recipes)

Feel free to ask us questions anytime on irc: #heavywater on freenode

## Custom Resources

TODO (resource usage documentation coming)

## Amazon Web Services

Due to the old version of Chef used on Amazon Web Services in order to
succesfully run this cookbook you will need to add the
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
5. Create new Pull Request against the `develop` branch
