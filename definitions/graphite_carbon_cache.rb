define :graphite_carbon_cache do

  node.run_state["graphite"]["carbon_cache"] ||= []
  conf_obj = node.run_state["graphite"]["carbon_cache"].find { |i| i[:name] == params[:name] }

  if conf_obj.nil?
    node.run_state["graphite"]["carbon_cache"] << {
      :name => params[:name],
      :config => params.fetch(:config, {})
    }
  else
    index = node.run_state["graphite"]["carbon_cache"].index(conf_obj)
    node.run_state["graphite"]["carbon_cache"][index][:config].merge!(params[:config])
  end

end
