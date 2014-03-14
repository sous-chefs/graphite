require 'spec_helper'
load_provider("graphite", "web_config")
describe Chef::Provider::GraphiteWebConfig do

  # fixes weird bug with RSpec::Metadata.store_computed (~L94)
  # and handling around description_args (possibly?)
  metadata[:example_group][:description]

  let(:runner) do
    ChefSpec::Runner.new(step_into: ['graphite_web_config'])
  end
  let(:node) { runner.node }
  let(:chef_run) { runner.converge("graphite_fixtures::graphite_web_config_#{action}") }

  describe "with the create action" do
    let(:action) { "create" }

    it "write the python config file at the given path" do
      expect(chef_run).to create_file("/opt/blueberries/love.py")
    end

  end

  describe "#optimistic_loader_code" do

    it "adds python code for optimistic loading"

  end

  describe "#dynamic_template_name" do

    it "returns a filename with .py extension removed"

  end
end
