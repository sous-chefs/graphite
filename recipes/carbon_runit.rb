include_recipe "#{cookbook_name}::carbon"

runit_service "carbon-cache" do
  finish_script true
end
