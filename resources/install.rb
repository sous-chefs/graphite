# frozen_string_literal: true

provides :graphite_install
unified_mode true

use '_partial/_paths'

include GraphiteCookbook::Helpers

property :version, String, default: '1.1.10'
property :install_type, Symbol, equal_to: %i(package pip source), default: :package
property :package_names, Hash, default: {
  'whisper' => {
    'package' => 'whisper',
    'source' => 'https://github.com/graphite-project/whisper/zipball/master',
  },
  'carbon' => {
    'package' => 'carbon',
    'source' => 'https://github.com/graphite-project/carbon/zipball/master',
  },
  'graphite_web' => {
    'package' => 'graphite-web',
    'source' => 'https://github.com/graphite-project/graphite-web/zipball/master',
  },
}
property :system_packages, Array, default: lazy { graphite_system_packages }
property :pip_packages, Array, default: %w(whisper carbon graphite_web)
property :platform_packages, Hash, default: lazy { graphite_platform_package_map }
property :manage_user, [true, false], default: true
property :manage_virtualenv, [true, false], default: true

default_action :install

action :install do
  group new_resource.group do
    system true
    action :create
    only_if { new_resource.manage_user }
  end

  user new_resource.user do
    system true
    group new_resource.group
    home '/var/lib/graphite'
    shell '/bin/false'
    manage_home true
    action :create
    only_if { new_resource.manage_user }
  end

  directory new_resource.base_dir do
    owner new_resource.user
    group new_resource.group
    recursive true
  end

  package new_resource.system_packages unless new_resource.system_packages.empty?

  case new_resource.install_type
  when :package
    package new_resource.platform_packages.values unless new_resource.platform_packages.empty?
  when :pip, :source
    execute "create #{new_resource.base_dir} virtualenv" do
      command "python3 -m venv #{new_resource.base_dir}"
      user new_resource.user
      group new_resource.group
      creates "#{new_resource.base_dir}/bin/pip"
      only_if { new_resource.manage_virtualenv }
    end

    new_resource.pip_packages.each do |pkg|
      execute "install #{pkg} into #{new_resource.base_dir}" do
        command graphite_pip_install_command(pkg)
        user new_resource.user
        group new_resource.group
        creates "#{new_resource.base_dir}/bin/#{graphite_pip_executable(pkg)}"
      end
    end
  end
end

action :remove do
  package new_resource.platform_packages.values do
    action :remove
    not_if { new_resource.platform_packages.empty? }
  end

  new_resource.pip_packages.each do |pkg|
    execute "remove #{pkg} from #{new_resource.base_dir}" do
      command "#{new_resource.base_dir}/bin/pip uninstall -y #{pkg}"
      only_if { %i(pip source).include?(new_resource.install_type) }
    end
  end
end

action_class do
  include GraphiteCookbook::Helpers

  def graphite_python_package_name(pkg)
    install_key = new_resource.install_type == :source ? 'source' : 'package'
    new_resource.package_names.fetch(pkg).fetch(install_key)
  end

  def graphite_pip_install_command(pkg)
    package_name = graphite_python_package_name(pkg)
    package_name = "#{package_name}==#{new_resource.version}" if new_resource.install_type == :pip
    "#{new_resource.base_dir}/bin/pip install --no-binary=:all: #{package_name}"
  end

  def graphite_pip_executable(pkg)
    {
      'whisper' => 'whisper-create.py',
      'carbon' => 'carbon-cache.py',
      'graphite_web' => 'django-admin.py',
    }.fetch(pkg, pkg)
  end
end
