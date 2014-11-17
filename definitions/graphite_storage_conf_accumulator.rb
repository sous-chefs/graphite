define :graphite_storage_conf_accumulator, :action => :create do

  node.run_state["graphite"] ||= Mash.new

  file_resource = nil

  begin
    file_resource = resources(:file => "storage-schemas.conf")
  rescue Chef::Exceptions::ResourceNotFound
    file_resource = file "storage-schemas.conf" do
      path "#{node['graphite']['base_dir']}/conf/storage-schemas.conf"
      owner node['graphite']['user']
      group node['graphite']['group']
      mode 0644
      content lazy {
        contents = "# This file is managed by Chef, your changes *will* be overwritten!\n\n"
        contents << ChefGraphite.ini_file(
          node.run_state["graphite"].fetch("storage_schema", [])
        )
      }
      action params[:action]
    end
  end

end
