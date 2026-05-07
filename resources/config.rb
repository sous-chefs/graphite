# frozen_string_literal: true

provides :graphite_config
unified_mode true

use '_partial/_paths'

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
  directory "#{new_resource.base_dir}/conf" do
    owner new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
  end

  directory new_resource.storage_dir do
    owner new_resource.user
    group new_resource.group
    recursive true
  end

  %w(log whisper rrd).each do |dir|
    directory "#{new_resource.storage_dir}/#{dir}" do
      owner new_resource.user
      group new_resource.group
      recursive true
    end
  end

  template "#{new_resource.base_dir}/conf/graphTemplates.conf" do
    cookbook 'graphite'
    source 'graphTemplates.conf.erb'
    mode '0755'
    variables(graph_templates: new_resource.graph_templates)
  end
end

action :delete do
  file "#{new_resource.base_dir}/conf/graphTemplates.conf" do
    action :delete
  end

  %W(#{new_resource.storage_dir}/rrd #{new_resource.storage_dir}/whisper #{new_resource.storage_dir}/log #{new_resource.storage_dir}).each do |dir|
    directory dir do
      recursive true
      action :delete
    end
  end
end
