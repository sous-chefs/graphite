include_recipe "#{cookbook_name}::carbon"

runit_service "twistd-carbon-cache"
