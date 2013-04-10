#
# Cookbook Name:: graphite
# Attributes:: graphite_web
#

default['graphite']['graphite_web']['uri'] = "https://launchpad.net/graphite/0.9/#{node['graphite']['version']}/+download/graphite-web-#{node['graphite']['version']}.tar.gz"
default['graphite']['graphite_web']['checksum'] = "4fd1d16cac3980fddc09dbf0a72243c7ae32444903258e1b65e28428a48948be"

default['graphite']['graphite_web']['cluster_servers'] = []
default['graphite']['graphite_web']['carbonlink_hosts'] = []

