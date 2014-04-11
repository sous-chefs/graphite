#
# A function which assists in carbon-cache service discover
#
def find_carbon_cache_services(node)
  caches = []
  case node['graphite']['carbon']['service_type']
  when 'runit'
    node['graphite']['carbon']['caches'].each do |instance, data|
      caches << "runit_service[carbon-cache-#{instance}]"
    end
  else
    caches << "service[carbon-cache]"
  end
  caches
end

def find_carbon_relay_services(node)
  relay = []
  case node['graphite']['carbon']['service_type']
    when 'runit'
      node['graphite']['carbon']['relay'].each do |instance, data|
        relays << "runit_service[carbon-relay-#{instance}]"
      end
    else
      relay << "service[carbon-relay]"
    end
    relay
end
