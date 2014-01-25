# Matchers for chefspec 3

if defined?(ChefSpec)
  def enable_runit_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:runit_service, :enable, resource_name)
  end
end
