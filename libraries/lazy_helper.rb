def external_lazy_needed?(node)
  Gem::Version.new(node['chef_packages']['chef']['version'])
                     .between?(Gem::Version.new('11.0.0'), Gem::Version.new('11.6.0'))
end
