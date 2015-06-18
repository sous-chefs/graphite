define :graphite_storage_schema do
  carbon_config = params[:config]
  carbon_action = params[:action]

  graphite_storage_conf_accumulator params[:name] do
    config carbon_config
    action carbon_action
  end
end
