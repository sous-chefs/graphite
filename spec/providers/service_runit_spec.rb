require "spec_helper"
load_provider("graphite", "service_runit")
load_resource("graphite", "service")

describe Chef::Provider::GraphiteServiceRunit do

  before do
    using_libraries("runit")
    node.set[:runit] = Mash.new
  end

  let(:resource_class) { Chef::Resource::GraphiteService }
  let(:resource_name) { "yabbadoo" }

  it "is whyrun support" do
    expect(provider).to be_whyrun_supported
  end

  shared_examples "manages runit service" do

    let(:resource) { provider.manage_runit_service(resource_action) }

    it "sets an action" do
      expect(resource.action).to eq([resource_action])
    end

    it "sets the service name" do
      expect(resource.service_name).to eq("carbon-yabbadoo")
    end

    it "sets the cookbook attribute to graphite" do
      expect(resource.cookbook).to eq("graphite")
    end

    it "sets the run_template_name attribute to carbon" do
      expect(resource.run_template_name).to eq("carbon")
    end

    it "sets the default_logger attribute to true" do
      expect(resource.default_logger).to be_true
    end

    it "sets the finish_script_template_name attribute to carbon" do
      expect(resource.finish_script_template_name).to eq("carbon")
    end

    it "sets the finish attribute to true" do
      expect(resource.finish).to be_true
    end

    it "sets the options attribute hash" do
      expect(resource.options).to eq(type: "yabbadoo", instance: nil)
    end
  end

  context "for :enable action" do

    before { new_resource.action(action) }
    let(:action) { :enable }

    describe "#manage_runit_service" do

      let(:resource_action) { :enable }

      include_examples "manages runit service"
    end

    it "adds the runit_service to the resource collection" do
      provider.run_action(action)

      expect(runner_resources).to include("runit_service[carbon-yabbadoo]")
    end
  end

  context "for :disable action" do

    before { new_resource.action(action) }
    let(:action) { :disable }

    describe "#manage_runit_service" do

      let(:resource_action) { :disable }

      include_examples "manages runit service"
    end

    it "adds the runit_service to the resource collection" do
      provider.run_action(action)

      expect(runner_resources).to include("runit_service[carbon-yabbadoo]")
    end
  end
end
