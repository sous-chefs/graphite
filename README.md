Description
===========

Installs and configures Graphite http://graphite.wikidot.com/

Requirements
============

* Ubuntu 10.04 (Lucid) - with default settings
* Ubuntu 11.10 (Oneiric) - change node[:graphite][:python_version] to "2.7"

Attributes
==========

* `node[:graphite][:password]` - Sets the default password for the graphite
  "root" user.
* `node['graphite']['carbon']['interface']` - The interface to bind carbon to.
  Will discover the interface's IPv4 address, otherwise will use `127.0.0.1` or
  appropriate `node['graphite']['carbon']['*_interface']` value.  Requires the
  [Network Addr](https://gist.github.com/1040543) Ohai plugin.

Usage
=====

Build a stand-alone Graphite installation.

```json
"run_list": [
    "recipe[graphite]"
]
```

Integrate with Ganglia. You'll want at least one monitor node
(i.e. `recipe[ganglia]`) node to be running to use it.

```json
"run_list": [
    "recipe[graphite::ganglia]"
]
```

Caveats
=======

Ships with two default schemas, stats.* (for Etsy's statsd) and a
catchall that matches anything. The catchall retains minutely data for
13 months, as in the default config. stats retains data every 10 seconds
for 6 hours, every minute for a week, and every 10 minutes for 5 years.
