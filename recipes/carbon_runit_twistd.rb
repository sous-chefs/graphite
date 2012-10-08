include_recipe "#{cookbook_name}::carbon"

runit_service "twistd-carbon-cache" do
    subscribes( :restart,
              "template[#{node['graphite']['base_dir']}/conf/carbon.conf" )
end
