define :graphite_storage_conf_accumulator, :action => :create, :file => 'storage-schemas.conf' do

  # Create the storage-schemas.conf configuration file
  storage_conf_resource =
    begin
      resources(template: params[:file])
    rescue Chef::Exceptions::ResourceNotFound
      template params[:file] do
        path "#{node['graphite']['base_dir']}/conf/#{params[:file]}"
        cookbook 'graphite'
        source 'carbon.conf.erb'
        owner node['graphite']['user']
        group node['graphite']['group']
        mode 0644
        variables config: []
        action params[:action]
      end
    end

  # Accumulate the configuration data in Chef::Resource::Template#variables
  if params[:config].is_a?(Hash)
    config_variable = storage_conf_resource.variables[:config]
    conf_obj = config_variable.find { |i| i[:name] == params[:name] }

    if conf_obj.nil?
      config_variable << {
        name: params[:name],
        config: params[:config]
      }
    else
      index = config_variable.index(conf_obj)
      config_variable[index][:config].merge!(params[:config])
    end
  end

  # For notifications support (only works in Chef >= 12).
  # @example
  #   my_definition = graphite_storage_conf_accumulator 'carbon' do
  #     config(
  #       pattern: '^carbon\.',
  #       retentions: '60:90d'
  #     )
  #   end
  #   my_definition.notifies :run, 'execute[thing]'
  storage_conf_resource
end
