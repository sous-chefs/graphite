# frozen_string_literal: true

provides :graphite_storage_config
unified_mode true

use '_partial/_paths'

property :path, String, default: lazy { "#{base_dir}/conf/storage-schemas.conf" }
property :sort_schemas, [true, false], default: true
property :schemas, Array, default: []

default_action :create

action :create do
  directory ::File.dirname(new_resource.path) do
    owner new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
  end

  file new_resource.path do
    owner new_resource.user
    group new_resource.group
    mode '0644'
    content graphite_storage_config_content
  end
end

action :delete do
  file new_resource.path do
    action :delete
  end
end

action_class do
  include GraphiteCookbook::Helpers

  def graphite_storage_config_content
    content = explicit_storage_resources
    content = collected_storage_resources if content.empty?

    graphite_header + ChefGraphite.ini_file(content, new_resource.sort_schemas)
  end

  def explicit_storage_resources
    Array(new_resource.schemas).map do |resource|
      resource = { name: resource[:name] || resource['name'], config: resource[:config] || resource['config'] } if resource.is_a?(Hash)
      {
        name: resource[:name],
        config: resource[:config] || {},
      }
    end
  end

  def collected_storage_resources
    resources = run_context.resource_collection.select { |resource| resource.resource_name == :graphite_storage_schema }
    resources.map { |resource| graphite_resource_hash(resource) }
  end
end
