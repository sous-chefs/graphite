require 'chefspec'
require 'chefspec/berkshelf'
require_relative 'support/example_groups/provider_example_group'
require_relative 'support/example_groups/resource_example_group'

RSpec.configure do |config|
  config.color = true
  config.log_level = :error

  config.include Chef::ProviderExampleGroup,
    type: :provider,
    example_group: lambda { |example_group, metadata|
      metadata[:type].nil? && %r{spec/providers/} =~ example_group[:file_path]
    }

  config.include Chef::ResourceExampleGroup,
    type: :resource,
    example_group: lambda { |example_group, metadata|
      metadata[:type].nil? && %r{spec/resources/} =~ example_group[:file_path]
    }
end

def load_resource(cookbook, lwrp)
  require 'chef/resource/lwrp_base'
  name = class_name_for_lwrp(cookbook, lwrp)
  unless Chef::Resource.const_defined?(name)
    Chef::Resource::LWRPBase.build_from_file(
      cookbook,
      File.join(File.dirname(__FILE__), %W(.. resources #{lwrp}.rb)),
      nil
    )
  end
end

def load_provider(cookbook, lwrp)
  require 'chef/provider/lwrp_base'
  name = class_name_for_lwrp(cookbook, lwrp)
  unless Chef::Provider.const_defined?(name)
    Chef::Provider::LWRPBase.build_from_file(
      cookbook,
      File.join(File.dirname(__FILE__), %W(.. providers #{lwrp}.rb)),
      nil
    )
  end
end

def class_name_for_lwrp(cookbook, lwrp)
  require 'chef/mixin/convert_to_class_name'
  Chef::Mixin::ConvertToClassName.convert_to_class_name(
    Chef::Mixin::ConvertToClassName.filename_to_qualified_string(cookbook, lwrp)
  )
end
