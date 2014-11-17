define :graphite_carbon_relay do

  conf_obj = node.run_state["graphite"]["carbon_relay"].find { |i| i[:name] == params[:name] }

  if conf_obj.nil?
    node.run_state["graphite"]["carbon_relay"] << {
      :name => params[:name],
      :config => params.fetch(:config, {})
    }
  else
    index = node.run_state["graphite"]["carbon_relay"].index(conf_obj)
    node.run_state["graphite"]["carbon_relay"][index][:config].merge!(params[:config])
  end

end
