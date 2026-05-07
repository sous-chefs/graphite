# frozen_string_literal: true

provides :graphite_web
unified_mode true

use '_partial/_paths'

property :doc_root, String, default: '/opt/graphite/webapp'
property :manage_selinux_context, [true, false], default: true
property :graph_templates, Array, default: [
  {
    'name' => 'default',
    'background' => 'black',
    'foreground' => 'white',
    'majorLine' => 'white',
    'minorLine' => 'grey',
    'lineColors' => 'blue,green,red,purple,brown,yellow,aqua,grey,magenta,pink,gold,rose',
    'fontName' => 'Sans',
    'fontSize' => '10',
    'fontBold' => 'False',
    'fontItalic' => 'False',
  },
]

default_action :create

action :create do
  directory "#{new_resource.storage_dir}/log/webapp" do
    owner new_resource.user
    group new_resource.group
    recursive true
  end

  %w(info.log exception.log access.log error.log).each do |log_file|
    file "#{new_resource.storage_dir}/log/webapp/#{log_file}" do
      owner new_resource.user
      group new_resource.group
    end
  end

  execute 'config selinux context' do
    command "chcon -R -h -t httpd_log_t #{new_resource.storage_dir}/log/webapp"
    only_if 'sestatus | grep enabled'
    only_if { new_resource.manage_selinux_context }
  end

  directory "#{new_resource.doc_root}/graphite" do
    owner new_resource.user
    group new_resource.group
    recursive true
  end

  template "#{new_resource.base_dir}/conf/graphTemplates.conf" do
    cookbook 'graphite'
    source 'graphTemplates.conf.erb'
    mode '0755'
    variables(graph_templates: new_resource.graph_templates)
  end
end

action :delete do
  %w(info.log exception.log access.log error.log).each do |log_file|
    file "#{new_resource.storage_dir}/log/webapp/#{log_file}" do
      action :delete
    end
  end

  directory "#{new_resource.storage_dir}/log/webapp" do
    recursive true
    action :delete
  end
end
