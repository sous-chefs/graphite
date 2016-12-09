class Chef
  module ResourceExampleGroup
    def self.included(base)
      base.class_eval do
        metadata[:type] = :resource
        metadata[:example_group][:description]

        let(:resource) do
          described_class.new(resource_name)
        end

        let(:resource_name) do
          raise NotImplementedError, <<-MSG.gsub(/^\s+/, '')
            Name for the #{described_class} resource must be set.
            Implement an Rspec let helper like the following:
            let(:resource_name) { "my_cool_name" }
          MSG
        end
      end
    end
  end
end
