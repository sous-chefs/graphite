define :graphite_carbon_conf_accumulator, :action => :create, :file => 'carbon.conf'  do
  # The backend can never be nil
  backend = params[:backend].nil? ? 'whisper' : params[:backend]

  # Get the backend package name and its attributes
  backend_name, backend_attributes =
    if params[:backend].is_a?(Hash)
      attrs = params[:backend].dup
      [attrs.delete('name'), attrs]
    else
      [params[:backend], {}]
    end

  # Install the backend, whisper
  backend_pkg_resource =
    begin
      resources(python_pip: backend_name)
    rescue Chef::Exceptions::ResourceNotFound
      python_pip backend_name do
        Chef::Log.info "Installing storage backend: #{package_name}"
        only_if { params[:action] == :create }
        action :install
      end
    end
  # Pass the attributes to the package resource
  backend_attributes.each do |attr, value|
    backend_pkg_resource.send(attr, value)
  end

  # Create the carbon.conf configuration file
  carbon_conf_resource =
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
  if params.key?(:type) && params[:config].is_a?(Hash)
    config_variable = carbon_conf_resource.variables[:config]
    conf_obj = config_variable.find { |i| i[:name] == params[:name] }

    if conf_obj.nil?
      config_variable << {
        type: params[:type].to_s,
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
  #   my_definition = graphite_carbon_conf_accumulator 'default' do
  #       enable_logrotation: true,
  #       user: 'graphite',
  #       max_cache_size: 'inf',
  #       max_updates_per_second: 500,
  #       max_creates_per_minute: 50,
  #       line_receiver_interface: '0.0.0.0',
  #       line_receiver_port: 2003,
  #       udp_receiver_port: 2003,
  #       pickle_receiver_port: 2004,
  #       enable_udp_listener: true,
  #       cache_query_port: '7002',
  #       cache_write_strategy: 'sorted',
  #       use_flow_control: true,
  #       log_updates: false,
  #       log_cache_hits: false,
  #       whisper_autoflush: false
  #   end
  #   my_definition.notifies :run, 'execute[thing]'
  carbon_conf_resource
end
