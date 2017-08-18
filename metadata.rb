name             'graphite'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs/Configures graphite'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.5'

supports 'ubuntu'
supports 'debian'
supports 'redhat'
supports 'centos'
supports 'scientific'
supports 'oracle'

depends  'poise-python', '>= 1.5'
depends  'runit', '>= 1.2'
depends  'build-essential'

source_url 'https://github.com/sous-chefs/graphite'
issues_url 'https://github.com/sous-chefs/graphite/issues'
chef_version '>= 12.11' if respond_to?(:chef_version)
