Description
===========

Installs and configures Graphite http://graphite.wikidot.com/

Requirements
============

* Ubuntu 10.04 / Ubuntu 12.04
* Debian
* RHEL and derivatives (Centos, Amazon Linux, Oracle Linux, Scientific Linux)
* Fedora

Attributes
==========

* `node['graphite']['version']` - version of graphite to install (defaults to 0.9.10)
* `node['graphite']['password']` - password for graphite root user (default to `change_me` and is only used if encrypted databag isn't)
* `node['graphite']['chef_role']` - chef role name for graphite instances, used by the *federated* recipe (defaults to "graphite")
* `node['graphite']['url']` - url of the graphite server (defaults to graphite)
* `node['graphite']['url_aliases']` - array of url aliases (defaults to nil)
* `node['graphite']['listen_port']` - port to listen on (defaults to 80)
* `node['graphite']['base_dir']` = "/opt/graphite"
* `node['graphite']['doc_root']` = "/opt/graphite/webapp"
* `node['graphite']['storage_dir']` = "/opt/graphite/storage"
* `node['graphite']['django_root']` = "@DJANGO_ROOT@" - configurable path to your django installation
* `node['graphite']['timezone']` - set the timezone for the graphite web interface, defaults to America/Los_Angeles
* `node['graphite']['whisper']['uri']` - download url for whisper
* `node['graphite']['whisper']['checksum']` - checksum of the whisper download
* `node['graphite']['encrypted_data_bag']['name']` - the name of the encrypted data bag containing the default password for the graphite "root" user. If this attribute is set it will not use `node['graphite']['password']`.

carbon-cache.py attributes
--------------------------

* `node['graphite']['storage_schemas']` - an array with retention rates for storing metrics, used to generate the *storage-schemas.conf* file ([see the example below](#storage_schemas-example))
* `node['graphite']['carbon']['uri']` - download url for carbon
* `node['graphite']['carbon']['checksum']` - checksum for the carbon download
* `node['graphite']['carbon']['line_receiver_interface']` - line interface IP (defaults to 0.0.0.0)
* `node['graphite']['carbon']['line_receiver_port']` - line interface port (defaults to 2003)
* `node['graphite']['carbon']['enable_udp_listener']` - set this to "True" to enable the UDP listener (defaults to "False")
* `node['graphite']['carbon']['udp_receiver_interface']` - line interface IP for UDP listener (defaults to 0.0.0.0)
* `node['graphite']['carbon']['udp_receiver_port']` - line interface port for UDP listener (defaults to 2003)
* `node['graphite']['carbon']['pickle_receiver_interface']` - pickle receiver IP (defaults to 0.0.0.0)
* `node['graphite']['carbon']['pickle_receiver_port']` - pickle receiver port (defaults to 2004)
* `node['graphite']['carbon']['use_insecure_unpickler']` - set this to "True" to use the old-fashioned insecure unpickler (defaults to "False")
* `node['graphite']['carbon']['cache_query_interface']` - cache query IP (defaults to 0.0.0.0)
* `node['graphite']['carbon']['cache_query_port']` - cache query port (defaults to 7002)
* `node['graphite']['carbon']['use_flow_control']` - set this to "False" to drop datapoints received after the cache reaches *MAX_CACHE_SIZE* (defaults to "True")
* `node['graphite']['carbon']['max_cache_size']` - max size of the carbon cache (defaults to "inf")
* `node['graphite']['carbon']['max_creates_per_second']` - max number of new metrics to create per second (defaults to "inf")
* `node['graphite']['carbon']['max_updates_per_second']` - max updates to carbon per second (defaults to "1000")
* `node['graphite']['carbon']['log_whisper_updates']` - log updates to whisper (defaults to "False")
* `node['graphite']['carbon']['whisper_autoflush']` - set this option to "True" if you want whisper to write synchronously (defaults to "False")
* `node['graphite']['carbon']['service_type']` - init service to use for carbon (defaults to runit)

carbon-relay.py attributes
--------------------------

* `node['graphite']['relay_rules']` - an array with relay rules for sending metrics to a certain backends, used to generate the *relay-rules.conf* file ([see the example below](#relay_rules-example))
* `node['graphite']['carbon']['relay']['line_receiver_interface']` - line interface IP (defaults to 0.0.0.0)
* `node['graphite']['carbon']['relay']['line_receiver_port']` - line interface port (defaults to 2013)
* `node['graphite']['carbon']['relay']['pickle_receiver_interface']` - pickle receiver IP (defaults to 0.0.0.0)
* `node['graphite']['carbon']['relay']['pickle_receiver_port']` - pickle receiver port (defaults to 2014)
* `node['graphite']['carbon']['relay']['relay_method']` - choose between *consistent-hashing* and *rules* (defaults to "rules")
* `node['graphite']['carbon']['relay']['replication_factor']` - used to replicate datapoint data to more than one machine (defaults to 1)
* `node['graphite']['carbon']['relay']['destinations']` - list of carbon daemons to send metrics to
* `node['graphite']['carbon']['relay']['max_datapoints_per_message']` - maximum datapoints to send in a message between carbon daemons (defaults to 500)
* `node['graphite']['carbon']['relay']['max_queue_size']` - maximum queue of messages used to comunicate to other carbon daemons (defaults to 10000)
* `node['graphite']['carbon']['relay']['use_flow_control']` - set this to "False" to drop datapoints received after the cache reaches *MAX_CACHE_SIZE* (defaults to "True")

carbon-aggregator.py attributes
-------------------------------

* `node['graphite']['storage_aggregation']` - an array with rules to configure how to aggregate data to lower-precision retentions, used to generate the *storage-aggregation.conf* file
* `node['graphite']['aggregation_rules']` - an array with rules that allow you to add several metrics together, used to generate the *aggregation-rules.conf* file ([see the example below](#aggregation_rules-example))
* `node['graphite']['carbon']['aggregator']['line_receiver_interface']` - line interface IP (defaults to 0.0.0.0)
* `node['graphite']['carbon']['aggregator']['line_receiver_port']` - line interface port (defaults to 2023)
* `node['graphite']['carbon']['aggregator']['pickle_receiver_interface']` - pickle receiver IP (defaults to 0.0.0.0)
* `node['graphite']['carbon']['aggregator']['pickle_receiver_port']` - pickle receiver port (defaults to 2024)
* `node['graphite']['carbon']['aggregator']['destinations']` - list of carbon daemons to send metrics to
* `node['graphite']['carbon']['aggregator']['replication_factor']` - used to add redundancy to your data by replicating every datapoing to more than one machinne (defaults to 1)
* `node['graphite']['carbon']['aggregator']['max_queue_size']` - maximum queue of messages used to comunicate to other carbon daemons (defaults to 10000)
* `node['graphite']['carbon']['aggregator']['use_flow_control']` - set this to "False" to drop datapoints received after the cache reaches *MAX_CACHE_SIZE* (defaults to "True")
* `node['graphite']['carbon']['aggregator']['max_datapoints_per_message']` - maximum datapoints to send in a message between carbon daemons (defaults to 500)
* `node['graphite']['carbon']['aggregator']['max_aggregation_intervals']` - sets how many datapoints the aggregator remembers for each metric (defaults to 5)

graphite-web attributes
-----------------------

* `node['graphite']['web']['uri']` - download url for the graphite web ui
* `node['graphite']['web']['checksum']` - checksum for the graphite web ui download
* `node['graphite']['web']['debug']` - debug mode (defaults to "False")
* `node['graphite']['web']['admin_email']` - admin contact email (defaults to "admin@org.com")
* `node['graphite']['web']['cluster_servers']` - IP address (and optionally port) of the webapp on each remote server in the cluster
* `node['graphite']['web']['carbonlink_hosts']` - list the IP address, cache query port and instance name of each carbon cache instance on the **local** machine
* `node['graphite']['web_server']` - defaults to `apache`. Anything else will use uswsgi instead of apache
* `node['graphite']['user_account']` - user (default `node['apache']['user']`)
* `node['graphite']['group_account']` - group (default `node['apache']['group']`)
* `node['graphite']['create_user']`- should the user be created, boolean (defaults to false)
* `node['graphite']['ssl']['enabled']` - enable ssl in the apache2 vhost
* `node['graphite']['ssl']['cipher_suite']` - the cipher suite to use if ssl is enabled
* `node['graphite']['ssl']['certificate_file']` - the path to the certificate file if ssl is enabled
* `node['graphite']['ssl']['certificate_key_file']` - the path to the vertificate key file if ssl is enabled

storage_schemas example
-----------------------

```ruby
node.default['graphite']['storage_schemas'] = [
  {
    'name' => 'carbon',
    'pattern' => /^carbon\./,
    'retentions' => '1m:10d'
  },
  {
    'name' => 'sensu',
    'pattern' => /^sensu\./,
    'retentions' => '1m:30d'
  },
  {
    'name' => 'everything_30s7d_15m1m',
    'match-all' => true,
    'retentions' => '30s:7d,15m:1m'
  }
]
```

relay_rules example
-------------------

```ruby
node.default['graphite']['relay_rules'] = [
  {
    'name' => 'example_pattern',
    'pattern' => /^mydata\.foo\..+/,
    'destinations' => [ '10.1.2.3', '10.1.2.4:2004', 'myserver.mydomain.com' ]
  },{
    'name' => 'example_default',
    'default' => true,
    'destinations' => [ '10.1.2.5:2004' ]
  }
]
```

aggregation_rules example
-------------------------

```ruby
node.default['graphite']['aggregation_rules'] = [
  {
    'output_template' => '<env>.applications.<app>.all.requests',
    'frequency' => '60',
    'method' => 'sum',
    'input_pattern' => '<env>.applications.<app>.*.requests'
  },
  {
    'output_template' => '<env>.applications.<app>.all.latency',
    'frequency' => '60',
    'method' => 'sum',
    'input_pattern' => '<env>.applications.<app>.*.latency'
  },
]
```

Data Bags
=========

This cookbook optionally uses an encrypted data bag to store the graphite password.
If this data bag is not present the cookbook will use `node['graphite']['password']`
instead. To use the encrypted data bag set `node['graphite']['encrypted_data_bag']['name']`
with the name of the data bag you wish to use.

Helper Scripts
==============

The following helper scripts are included in the `graphite/bin` directory:

* `whisper-clean-this-node.sh` - this script cleans the whisper metrics that belong to other machines in the cluster. Usually used after synchronizing the *storage/whisper* directory. Uses the [whisper-clean.py](https://gist.github.com/rcrowley/3153844) script internally

Usage
=====

`recipe[graphite]` should build a stand-alone Graphite installation.

`recipe[graphite::ganglia]` integrates with Ganglia. You'll want at
least one monitor node (i.e. recipe[ganglia]) node to be running
to use it.
