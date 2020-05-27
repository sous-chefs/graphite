name             'graphite'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs/Configures graphite'

version          '1.3.0'

supports 'ubuntu'
supports 'debian'
supports 'redhat'
supports 'centos'
supports 'scientific'
supports 'oracle'

depends  'pyenv', '~> 3.1'

source_url 'https://github.com/sous-chefs/graphite'
issues_url 'https://github.com/sous-chefs/graphite/issues'
chef_version '>= 14'
