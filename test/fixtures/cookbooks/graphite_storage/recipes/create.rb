graphite_storage '/opt/graphite/storage' do
  version node['graphite']['version']
  action :create
end

graphite_storage 'instance-2' do
  prefix '/tmp/goodstuff'
  package_name 'https://example.com/pkg.tgz'
end
