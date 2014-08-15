module ChefGraphite

  module Mixins

    def resources_to_hashes(resources, whitelist = [])
      Array(resources).map do |resource|
        type = if whitelist.include?(resource.resource_name.to_sym)
                 resource.resource_name.to_s.split("_").last
               else
                 nil
               end
        {
          :type => type,
          :name => resource.name,
          :config => resource.config
        }
      end
    end

  end

end
