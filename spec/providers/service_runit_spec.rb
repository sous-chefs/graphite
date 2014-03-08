require 'spec_helper'

describe 'service_runit provider' do
  let(:runner) do
    ChefSpec::Runner.new(step_into: ['graphite_service']) do |node|
      node.automatic["platform_family"] = "debian"
    end
  end
  let(:node) { runner.node }
  let(:chef_run) { runner.converge("graphite_fixtures::graphite_service_runit_enable") }

  describe 'with the create action' do
    it "writes the runit service file" do
      expect(chef_run).to enable_runit_service("carbon-cache-a").with(
        cookbook: "graphite",
        run_template_name: "carbon",
        default_logger: true,
        finish_script_template_name: "carbon",
        finish: true,
        options: {type: "cache", instance: "a"}
      )
    end
  end

  describe 'with the delete action' do
    it "removes the runit service file" do
    end
  end

end
