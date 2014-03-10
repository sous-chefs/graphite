require "spec_helper"

load_resource("graphite", "service")
load_provider("graphite", "service_runit")

describe Chef::Resource::GraphiteService do

  let(:resource) { described_class.new("mega:beta") }

  it "sets the name attribute to name" do
    expect(resource.name).to eq("mega:beta")
  end

  it "action defaults to :enable" do
    expect(resource.action).to eq(:enable)
  end

  it "actions include :disable" do
    expect(resource.allowed_actions).to include(:disable)
  end

  it "provider defaults the runit service" do
    expect(resource.provider).to eq(Chef::Provider::GraphiteServiceRunit)
  end

  describe "#service_name" do

    it "returns a string with carbon prefixed and colons replaced" do
      expect(resource.service_name).to eq("carbon-mega-beta")
    end
  end

  describe "#type" do

    it "returns the type portion of name" do
      expect(resource.type).to eq("mega")
    end

    it "returns the type portion of name when no instance is given" do
      resource.name("charlie")
      expect(resource.type).to eq("charlie")
    end
  end

  describe "#instance" do

    it "returns the instance portion of name" do
      expect(resource.instance).to eq("beta")
    end

    it "returns nil when no instance is given" do
      resource.name("charlie")
      expect(resource.instance).to be_nil
    end
  end
end
