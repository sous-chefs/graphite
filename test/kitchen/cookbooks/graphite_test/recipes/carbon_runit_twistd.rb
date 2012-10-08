# Remove the standard 'carbon-cache.py" runit service, just in case..
# If this is running at the time the twistd-carbon-cache is installed,
# it probably won't work!
r = begin
      resources(:service => "carbon-cache")
    rescue Chef::Exceptions::ResourceNotFound
      nil
    end

ruby_block "remove previous carbon-cache service" do
  block do
    r.run_action(:disable)
    r.run_action(:remove)
  end
  not_if do
    r.nil?
  end
end

node.override['graphite']['carbon']['service_type'] = "runit_twistd"
