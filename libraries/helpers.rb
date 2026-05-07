# frozen_string_literal: true

module GraphiteCookbook
  module Helpers
    def graphite_header
      "# This file is managed by Chef, your changes *will* be overwritten!\n\n"
    end

    def graphite_system_packages
      case node['platform_family']
      when 'debian'
        %w(python3-venv python3-dev libcairo2-dev libffi-dev build-essential python3-rrdtool)
      when 'rhel', 'fedora', 'amazon'
        %w(python3 python3-devel cairo-devel libffi-devel gcc make rrdtool-python3)
      else
        []
      end
    end

    def graphite_platform_package_map
      if platform_family?('debian')
        {
          'whisper' => 'python3-whisper',
          'carbon' => 'graphite-carbon',
          'graphite_web' => 'graphite-web',
        }
      else
        {}
      end
    end

    def graphite_resource_hash(resource, type = nil)
      {
        type: type,
        name: resource.name,
        config: resource.config || {},
      }
    end
  end
end
