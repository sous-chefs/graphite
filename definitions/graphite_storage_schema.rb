define :graphite_storage_schema do

  Chef::Log.info("!!!DEBUG: params #{params.inspect}")

  node.run_state["graphite"] ||= Mash.new
  node.run_state["graphite"]["storage_schema"] ||= []
  conf_obj = node.run_state["graphite"]["storage_schema"].find { |i| i[:name] == params[:name] }

  if conf_obj.nil?
    node.run_state["graphite"]["storage_schema"] << {
      :name => params[:name],
      :config => params.fetch(:config, {})
    }
  else
    index = node.run_state["graphite"]["storage_schema"].index(conf_obj)
    node.run_state["graphite"]["storage_schema"][index][:config].merge!(params[:config])
  end


  Chef::Log.info("!!!!DEBUG graphite run_state: #{node.run_state['graphite']}")
end
