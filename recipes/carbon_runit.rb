include_recipe "#{cookbook_name}::carbon"

runit_service "carbon-cache" do
  finish_script true
  subscribes( :restart,
              "template[#{node['graphite']['base_dir']}/conf/carbon.conf" )
end
