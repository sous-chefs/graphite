# frozen_string_literal: true

provides :graphite_web_config
unified_mode true

property :path, String, name_property: true
property :config, Hash, default: {}
property :dynamic_template, String, default: 'local_settings_dynamic.py'

default_action :create

action :create do
  file new_resource.path do
    content graphite_web_config_content
    action :create
  end
end

action :delete do
  file new_resource.path do
    action :delete
  end
end

action_class do
  include GraphiteCookbook::Helpers

  def graphite_web_config_content
    graphite_header +
      ChefGraphite::PythonWriter.new(new_resource.config, upcase_root_keys: true).to_s +
      optimistic_loader_code
  end

  def optimistic_loader_code
    <<~PYTHON

      try:
        from graphite.#{dynamic_template_name} import *
      except ImportError:
        pass
    PYTHON
  end

  def dynamic_template_name
    ::File.basename(new_resource.dynamic_template, '.py')
  end
end
