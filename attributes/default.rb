#
# Cookbook Name:: graphite
# Attributes:: default
#

default['graphite']['version'] = '0.9.12'
default['graphite']['twisted_version'] = '13.1'
default['graphite']['django_version'] = '1.5.5'
default['graphite']['password'] = 'change_me'
default['graphite']['chef_role'] = 'graphite'
default['graphite']['user'] = 'graphite'
default['graphite']['group'] = 'graphite'
default['graphite']['listen_port'] = 80
default['graphite']['base_dir'] = '/opt/graphite'
default['graphite']['doc_root'] = '/opt/graphite/webapp'
default['graphite']['storage_dir'] = '/opt/graphite/storage'
default['graphite']['install_type'] = 'package'
default['graphite']['package_names'] = {
  'whisper' => {
    'package' => 'whisper',
    'source' => 'https://github.com/graphite-project/whisper/zipball/master'
  },
  'carbon' => {
    'package' => 'carbon',
    'source' => 'https://github.com/graphite-project/graphite-web/zipball/master'
  },
  'graphite_web' => {
    'package' => 'graphite-web',
    'source' => 'https://github.com/graphite-project/graphite-web/zipball/master'
  }
}

default['graphite']['graph_templates'] = [
  {
    'name' => 'default',
    'background' => 'black',
    'foreground' => 'white',
    'majorLine' => 'white',
    'minorLine' => 'grey',
    'lineColors' => 'blue,green,red,purple,brown,yellow,aqua,grey,magenta,pink,gold,rose',
    'fontName' => 'Sans',
    'fontSize' => '10',
    'fontBold' => 'False',
    'fontItalic' => 'False'
  }
]

default['graphite']['system_packages'] =
  case node['platform_family']
  when 'debian'
    %w{python-cairo-dev python-rrdtool}
  when 'rhel'
    case node['platform']
    when 'amazon'
      %w{pycairo-devel python-rrdtool bitmap}
    else
      %w{pycairo-devel python-rrdtool bitmap bitmap-fonts}
    end
  else
    []
  end
