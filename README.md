Description
===========

Installs and configures Graphite http://graphite.wikidot.com/

Requirements
============

* Ubuntu 10.04 (Lucid) - with default settings
* Ubuntu 11.10 (Oneiric) or newer - change node[:graphite][:python_version] to "2.7"

Attributes
==========

The name of the encrypted data bag containing the default password for
the graphite "root" user.  If this attribute is set it will not use
`node[:graphite][:password]`.

* `node['graphite']['encrypted_data_bag']['name']`

The default password for graphite "root" user.

* `node[:graphite][:password]`

Set the timezone for the graphite web interface, defaults to America/Los_Angeles

* `node[:graphite][:timezone]`

Usage
=====

`recipe[graphite]` should build a stand-alone Graphite installation.

`recipe[graphite::ganglia]` integrates with Ganglia. You'll want at
least one monitor node (i.e. recipe[ganglia]) node to be running
to use it.
