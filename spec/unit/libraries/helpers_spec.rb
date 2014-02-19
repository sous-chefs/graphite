require_relative '../../../libraries/helpers'

describe 'find_carbon_cache_services' do
  let(:node) do
    Hash[
      'graphite' => {
        'carbon' => {
          'service_type' => 'runit',
          'caches' => {
            'a' => { 'line_reciever_port' => 2003 },
            'b' => { 'line_reciever_port' => 2004 },
            'c' => { 'line_receiver_port' => 2005 }
          }
        }
      }
    ]
  end

  context 'when a single carbon-cache service is defined and run under runit' do
    before do
      node['graphite']['carbon']['caches'].delete('b')
      node['graphite']['carbon']['caches'].delete('c')
    end

    it 'should return a single runit_service carbon-cache service name' do
      caches = find_carbon_cache_services(node)
      caches.should == [
        'runit_service[carbon-cache-a]',
      ]
    end
  end

  context 'when multiple carbon-cache services are defined and run under runit' do
    it 'should return multiple runit_service carbon-cache service names' do
      caches = find_carbon_cache_services(node)
      caches.sort.should == [
        'runit_service[carbon-cache-a]',
        'runit_service[carbon-cache-b]',
        'runit_service[carbon-cache-c]'
      ]
    end
  end


  context 'when a single carbon-cache service is defined and not run under runit' do
    before do
      node['graphite']['carbon']['service_type'] = ""
      node['graphite']['carbon']['caches'].delete('b')
      node['graphite']['carbon']['caches'].delete('c')
    end

    it 'should return a single service carbon-cache service name' do
      caches = find_carbon_cache_services(node)
      caches.sort.should == ['service[carbon-cache]']
    end
  end

  context 'when multiple carbon-cache services are defined and not run under runit' do
    before do
      node['graphite']['carbon']['service_type'] = ""
    end

    it 'should return a single service carbon-cache service name' do
      caches = find_carbon_cache_services(node)
      caches.sort.should == ['service[carbon-cache]']
    end
  end
end
