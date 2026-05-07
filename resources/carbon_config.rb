# frozen_string_literal: true

provides :graphite_carbon_config
unified_mode true

use '_partial/_paths'

property :path, String, default: lazy { "#{base_dir}/conf/carbon.conf" }
property :sort_configs, [true, false], default: true
property :caches, Array, default: []
property :relays, Array, default: []
property :aggregators, Array, default: []

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
    content graphite_carbon_config_content
  end
end

action :delete do
  file new_resource.path do
    action :delete
  end
end

action_class do
  include GraphiteCookbook::Helpers

  def graphite_carbon_config_content
    content = explicit_carbon_resources
    content = collected_carbon_resources if content.empty?

    graphite_header + ChefGraphite.ini_file(content, new_resource.sort_configs)
  end

  def explicit_carbon_resources
    typed_resource_hashes(new_resource.caches, 'cache') +
      typed_resource_hashes(new_resource.relays, 'relay') +
      typed_resource_hashes(new_resource.aggregators, 'aggregator')
  end

  def typed_resource_hashes(resources, type)
    Array(resources).map do |resource|
      resource = { name: resource[:name] || resource['name'], config: resource[:config] || resource['config'] } if resource.is_a?(Hash)
      {
        type: type,
        name: resource[:name],
        config: resource[:config] || {},
      }
    end
  end

  def collected_carbon_resources
    resources = run_context.resource_collection.select do |resource|
      %i(graphite_carbon_cache graphite_carbon_relay graphite_carbon_aggregator).include?(resource.resource_name)
    end

    resources.map do |resource|
      type = resource.resource_name.to_s.sub('graphite_carbon_', '')
      graphite_resource_hash(resource, type)
    end
  end
end
