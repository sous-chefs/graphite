define :graphite_carbon_cache do
  carbon_backend = params[:backend]
  carbon_config = params[:config]
  carbon_action = params[:action]

  graphite_carbon_conf_accumulator params[:name] do
    type :cache
    backend carbon_backend
    config carbon_config
    action carbon_action
  end
end
