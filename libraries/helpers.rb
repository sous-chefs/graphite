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
