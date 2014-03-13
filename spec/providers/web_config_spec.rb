require 'spec_helper'

describe 'graphite_web_config provider' do
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

end
