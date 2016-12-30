class Chef
  module ProviderExampleGroup
    def using_lw_resource(cookbook, lwrp)
      name = class_name_for_lwrp(cookbook, lwrp)
      resource_file = run_context.cookbook_collection[cookbook]
                                 .resource_filenames.find { |f| ::File.basename(f, '.rb') == lwrp }

      using_libraries(cookbook)

      unless Chef::Resource.const_defined?(name)
        Chef::Resource::LWRPBase.build_from_file(
          cookbook,
          resource_file,
          run_context
        )
      end
    end

    def using_lw_provider(cookbook, lwrp)
      name = class_name_for_lwrp(cookbook, lwrp)
      resource_file = run_context.cookbook_collection[cookbook]
                                 .provider_filenames.find { |f| ::File.basename(f, '.rb') == lwrp }

      using_libraries(cookbook)

      unless Chef::Provider.const_defined?(name)
        Chef::Provider::LWRPBase.build_from_file(
          cookbook,
          resource_file,
          run_context
        )
      end
    end

    def using_libraries(cookbook)
      run_context.cookbook_collection[cookbook].library_filenames.each do |f|
        require(f)
      end
    end

    def runner_resources
      runner.resource_collection.all_resources.map(&:to_s)
    end

    def self.included(base)
      base.class_eval do
        metadata[:type] = :provider
        metadata[:example_group][:description]

        let(:new_resource) do
          resource_class.new(resource_name)
        end

        let(:node) do
          runner.node
        end

        let(:platform) do
          'ubuntu'
        end

        let(:provider) do
          described_class.new(new_resource, run_context)
        end

        let(:resource_class) do
          Chef::Resource.const_get(described_class.name.split('::').last)
        end

        let(:resource_name) do
          raise NotImplementedError, <<-MSG.gsub(/^\s+/, '')
            Name for the #{resource_class} resource must be set.
            Implement an Rspec let helper like the following:
            let(:resource_name) { "my_cool_name" }
          MSG
        end

        let(:run_context) do
          runner.converge
          runner.run_context
        end

        let(:runner) do
          step_into = Chef::Mixin::ConvertToClassName.convert_to_snake_case(
            resource_class.to_s, Chef::Resource.to_s
          )
          ChefSpec::SoloRunner.new(
            platform: platform, version: version, step_into: [step_into]
          )
        end

        let(:version) do
          '12.04'
        end
      end
    end
  end
end
