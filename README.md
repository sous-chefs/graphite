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

## Helper Scripts

TODO (optionally install carbonate if avail?)

## Usage

It's a library cookbook, intended to be used in your custom wrapper
cookbook to behave as needed. It's the building materials, not the
house.

For example usage consult the reference cookbook (link)

## Custom Resources

TODO document resource usage

Amazon Web Services
===================

Due to old version of Chef used on Amazon Web Services to succesfully run this cookbook add [`delayed_evaluator`](http://community.opscode.com/cookbooks/delayed_evaluator) recipe
to run list somewhere before `graphite` recipe.
