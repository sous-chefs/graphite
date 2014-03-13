require "spec_helper"

load_resource("graphite", "web_config")
load_provider("graphite", "web_config")

describe Chef::Resource::GraphiteWebConfig do

  let(:resource) { described_class.new("/opt/graphite/file.py") }

  it "sets the path attribute to name" do
    expect(resource.path).to eq("/opt/graphite/file.py")
  end

  it "action defaults to :create" do
    expect(resource.action).to eq(:create)
  end

end
