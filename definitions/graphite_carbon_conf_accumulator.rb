define :graphite_carbon_conf_accumulator, :action => :create do

  node.run_state["graphite"] ||= Mash.new

  file_resource = nil

  begin
    file_resource = resources(:file => "carbon.conf")
  rescue Chef::Exceptions::ResourceNotFound
    file_resource = file "carbon.conf" do
      path "#{node['graphite']['base_dir']}/conf/carbon.conf"
      owner node['graphite']['user']
      group node['graphite']['group']
      mode 0644
      content lazy {
        contents = "# This file is managed by Chef, your changes *will* be overwritten!\n\n"

        config_types = %w{ cache relay aggregator }.map { |type| "carbon_#{type}" }

        config_hashes = []

        config_types.each do |type|
          config_hashes += node.run_state["graphite"].fetch(type, [])
        end

        contents << ChefGraphite.ini_file(config_hashes)

      }
      action params[:action]
    end
  end

end
