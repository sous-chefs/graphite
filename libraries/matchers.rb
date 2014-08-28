if defined?(ChefSpec)
  def create_graphite_storage(name)
    ChefSpec::Matchers::ResourceMatcher.new(:graphite_storage, :create, name)
  end

  def delete_graphite_storage(name)
    ChefSpec::Matchers::ResourceMatcher.new(:graphite_storage, :delete, name)
  end

  def create_graphite_carbon_conf_accumulator(name)
    ChefSpec::Matchers::ResourceMatcher.new(:graphite_carbon_conf_accumulator, :create, name)
  end

  def enable_runit_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:runit_service, :enable, resource_name)
  end
end
