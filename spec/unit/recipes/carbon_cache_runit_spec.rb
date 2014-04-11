require 'chefspec'
require 'chefspec/librarian'

describe 'graphite::carbon_cache_runit' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
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

  it 'should include the runit cookbook' do
    expect(chef_run).to include_recipe('runit')
  end

  it 'should define 3 runit services named after each carbon cache' do
    expect(chef_run).to enable_runit_service('carbon-cache-a')
    expect(chef_run).to enable_runit_service('carbon-cache-b')
  end
end

