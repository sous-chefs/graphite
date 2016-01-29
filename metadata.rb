name             'graphite'
maintainer       'Heavy Water Software Inc.'
maintainer_email 'ops@hw-ops.com'
license          'Apache 2.0'
description      'Installs/Configures graphite'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.5'

supports 'ubuntu'
supports 'debian'
supports 'redhat'
supports 'centos'
supports 'amazon'
supports 'scientific'
supports 'oracle'
supports 'fedora'

depends  'python'
depends  'runit', '~> 1.0'
depends  'build-essential'
depends  'yum-epel'

suggests 'systemd'
suggests 'graphiti'
suggests 'delayed_evaluator'

source_url 'https://github.com/hw-cookbooks/graphite' if respond_to?(:source_url)
issues_url 'https://github.com/hw-cookbooks/graphite/issues' if respond_to?(:issues_url)
