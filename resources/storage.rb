# frozen_string_literal: true

provides :graphite_storage
unified_mode true

use '_partial/_paths'

property :path, String, name_property: true
property :package_name, String, default: 'whisper'
property :version, String
property :backend_type, String, default: 'whisper'
property :install_type, Symbol, equal_to: %i(package pip source), default: :package

default_action :create

action :create do
  directory new_resource.path do
    owner new_resource.user
    group new_resource.group
    recursive true
  end

  package 'python3-whisper' do
    only_if { new_resource.install_type == :package && platform_family?('debian') }
  end

  execute "install #{new_resource.package_name} into #{new_resource.base_dir}" do
    command lazy {
      package_name = new_resource.package_name
      package_name = "#{package_name}==#{new_resource.version}" if new_resource.version
      "#{new_resource.base_dir}/bin/pip install --no-binary=:all: #{package_name}"
    }
    user new_resource.user
    group new_resource.group
    only_if { %i(pip source).include?(new_resource.install_type) }
  end
end

action :delete do
  execute "remove #{new_resource.package_name} from #{new_resource.base_dir}" do
    command "#{new_resource.base_dir}/bin/pip uninstall -y #{new_resource.package_name}"
    only_if { %i(pip source).include?(new_resource.install_type) }
  end

  directory new_resource.path do
    recursive true
    action :delete
  end
end
