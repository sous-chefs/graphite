require 'chefspec'
require 'chefspec/librarian'
require 'chef/mixin/convert_to_class_name'

RSpec.configure do |config|
  config.log_level = :fatal
end

at_exit { ChefSpec::Coverage.report! } if ENV['COVERAGE']

def load_resource(cookbook, lwrp)
  require "chef/resource/lwrp_base"
  name = class_name_for_lwrp(cookbook, lwrp)
  unless Chef::Resource.const_defined?(name)
    Chef::Resource::LWRPBase.build_from_file(
      cookbook,
      File.join(File.dirname(__FILE__), %W{.. resources #{lwrp}.rb}),
      nil
    )
  end
end

def load_provider(cookbook, lwrp)
  require "chef/provider/lwrp_base"
  name = class_name_for_lwrp(cookbook, lwrp)
  unless Chef::Provider.const_defined?(name)
    Chef::Provider::LWRPBase.build_from_file(
      cookbook,
      File.join(File.dirname(__FILE__), %W{.. providers #{lwrp}.rb}),
      nil
    )
  end
end

def class_name_for_lwrp(cookbook, lwrp)
  Chef::Mixin::ConvertToClassName.convert_to_class_name(
    Chef::Mixin::ConvertToClassName.filename_to_qualified_string(cookbook, lwrp)
  )
end
