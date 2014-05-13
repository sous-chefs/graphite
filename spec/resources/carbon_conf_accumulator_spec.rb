require "spec_helper"
load_resource("graphite", "carbon_conf_accumulator")
require_relative "../../libraries/mixins"
require_relative "../../libraries/provider_carbon_conf_accumulator"

describe Chef::Resource::GraphiteCarbonConfAccumulator do

  let(:resource_name) { "foobar" }

  it "sets the name attribute to name" do
    expect(resource.name).to eq("foobar")
  end

  it "attribute file_resource defaults to file[carbon.conf]" do
    expect(resource.file_resource).to eq("file[carbon.conf]")
  end

  it "attribute file_resource takes a String value" do
    resource.file_resource("blahblah")

    expect(resource.file_resource).to eq("blahblah")
  end

  it "action defaults to :create" do
    expect(resource.action).to eq(:create)
  end

  it "provider defaults to GraphiteCarbonConfAccumulator" do
    expect(resource.provider).to eq(Chef::Provider::GraphiteCarbonConfAccumulator)
  end

  it "#carbon_resources returns a list of carbon-related Chef resource names" do
    expect(resource.carbon_resources.size).to eq(3)
    expect(resource.carbon_resources).to include(:graphite_carbon_cache)
    expect(resource.carbon_resources).to include(:graphite_carbon_relay)
    expect(resource.carbon_resources).to include(:graphite_carbon_aggregator)
  end
end
