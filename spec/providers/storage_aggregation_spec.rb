require_relative "../spec_helper"
load_resource("graphite", "storage_aggregation")
load_provider("graphite", "storage_aggregation")

describe Chef::Provider::GraphiteStorageAggregation do

  let(:resource_name) { "joe" }

  it "is whyrun support" do
    expect(provider).to be_whyrun_supported
  end

  it "for :create action, it exists" do
    expect(provider.run_action(:create))
  end
end
