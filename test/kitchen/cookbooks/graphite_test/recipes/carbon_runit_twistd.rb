# Remove the standard 'carbon-cache.py" runit service, just in case..
# If this is running at the time the twistd-carbon-cache is installed,
# it probably won't work!
runit_service "carbon-cache" do
  action [:disable, :remove]
end

node.override['graphite']['carbon']['service_type'] = "runit_twistd"
