class Chef
  module DefinitionExampleGroup
    def fake_recipe_run(&block)
      runner.converge('graphite::default').tap do |chef_run|
        recipe = Chef::Recipe.new('graphite_spec', 'default', chef_run.run_context)
        recipe.instance_eval(&block)

        runner2 = Chef::Runner.new(recipe.run_context)
        runner2.converge
      end
    end

    def self.included(base)
      base.class_eval do
        metadata[:type] = :definition
        metadata[:example_group][:description]

        let(:node) do
          runner.node
        end

        let(:platform) do
          'ubuntu'
        end

        let(:run_context) do
          recipe_run.run_context
        end

        let(:runner) do
          ChefSpec::Runner.new(platform: platform, version: version)
        end

        let(:version) do
          '12.04'
        end
      end
    end
  end
end
