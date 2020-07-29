name             'graphite'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs/Configures graphite'

version          '2.0.0'

supports 'ubuntu', '>= 16.0'
supports 'debian', '>= 9.0'
supports 'redhat', '>= 7.0'
supports 'centos', '>= 7.0'

depends  'pyenv', '>= 3.1'

source_url 'https://github.com/sous-chefs/graphite'
issues_url 'https://github.com/sous-chefs/graphite/issues'
chef_version '>= 14'
