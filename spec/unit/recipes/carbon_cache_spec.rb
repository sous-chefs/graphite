require 'chefspec'
require 'chefspec/librarian'

describe 'graphite::carbon_cache' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['graphite']['carbon']['service_type'] = 'runit'
      node.set['graphite']['base_dir'] = '/opt/graphite'
      node.set['graphite']['carbon']['caches']['a']['line_receiver_port'] = 2003
      node.set['graphite']['carbon']['caches']['a']['udp_receiver_port'] = 2003
      node.set['graphite']['carbon']['caches']['a']['pickle_receiver_port'] = 2004
      node.set['graphite']['carbon']['caches']['a']['cache_query_port'] = 7002
      node.set['graphite']['carbon']['caches']['b']['line_receiver_port'] = 2005
      node.set['graphite']['carbon']['caches']['b']['udp_receiver_port'] = 2005
      node.set['graphite']['carbon']['caches']['b']['pickle_receiver_port'] = 2006
      node.set['graphite']['carbon']['caches']['b']['cache_query_port'] = 7003

      # Work around for lack of platform defaults in runit
      node.set['runit']['sv_bin'] = '/usr/bin/sv'
    end.converge(described_recipe)
  end

  it 'should create the storage-schemas.conf file and restart each carbon-cache runit daemons' do
    expect(chef_run).to create_template('/opt/graphite/conf/storage-schemas.conf')

    resource = chef_run.template('/opt/graphite/conf/storage-schemas.conf')
    expect(resource).to notify('runit_service[carbon-cache-a]').to(:restart)
    expect(resource).to notify('runit_service[carbon-cache-b]').to(:restart)
  end

  it 'should delete the default storage-aggregation.conf file and restart each carbon-cache runit daemon' do
    expect(chef_run).to delete_file('/opt/graphite/conf/storage-aggregation.conf')

    resource = chef_run.file('/opt/graphite/conf/storage-aggregation.conf')
    expect(resource).to notify('runit_service[carbon-cache-a]').to(:restart)
    expect(resource).to notify('runit_service[carbon-cache-b]').to(:restart)
    expect(resource).to notify('runit_service[carbon-cache-c]').to(:restart)
  end

  it 'should create the storage-aggregation.conf file and restart each carbon-cache runit daemon' do
    chef_run.node.set['graphite']['storage_aggregation'] = [
      {
        'name' => 'all_min',
        'pattern' => '\.min$',
        'xFilesFactor' => '0.1',
        'aggregationMethod' => 'min'
      },
      {
        'name' => 'count',
        'pattern' => '\.count$',
        'xFilesFactor' => '0',
        'aggregationMethod' => 'sum'
      },
    ]
    chef_run.converge(described_recipe)

    expect(chef_run).to create_template('/opt/graphite/conf/storage-aggregation.conf')

    resource = chef_run.template('/opt/graphite/conf/storage-aggregation.conf')
    expect(resource).to notify('runit_service[carbon-cache-a]').to(:restart)
    expect(resource).to notify('runit_service[carbon-cache-b]').to(:restart)
  end

  it 'should include the graphite carbon cache runit recipe' do
    expect(chef_run).to include_recipe('graphite::carbon_cache_runit')
  end
end

