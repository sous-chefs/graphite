if defined?(ChefSpec)
  def create_graphite_storage(name)
    ChefSpec::Matchers::ResourceMatcher.new(:graphite_storage, :create, name)
  end

  def delete_graphite_storage(name)
    ChefSpec::Matchers::ResourceMatcher.new(:graphite_storage, :delete, name)
  end
end
