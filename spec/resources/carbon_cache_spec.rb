require "spec_helper"
load_resource("graphite", "carbon_cache")

describe Chef::Resource::GraphiteCarbonCache do

  let(:resource_name) { "alpha" }

  it "sets the default attribute to name" do
    expect(resource.name).to eq("alpha")
  end

  it "attribute backend defaults to whisper" do
    expect(resource.backend).to eq("whisper")
  end

  it "attribute backend takes a String value" do
    resource.backend("steven")

    expect(resource.backend).to eq("steven")
  end

  it "attribute backend takes a Hash value" do
    resource.backend("name" => "eric", "version" => 9)

    expect(resource.backend).to eq("name" => "eric", "version" => 9)
  end

  it "attribute config defaults to nil" do
    expect(resource.config).to be_nil
  end

  it "attribute config takes a Hash value" do
    resource.config("a" => "b")

    expect(resource.config).to eq("a" => "b")
  end

  it "action defaults to :create" do
    expect(resource.action).to eq(:create)
  end

  it "actions include :delete" do
    expect(resource.allowed_actions).to include(:delete)
  end

  describe "#backend_name" do

    it "returns backend if backend is a String" do
      resource.backend("whoomp")

      expect(resource.backend_name).to eq("whoomp")
    end

    it "returns name attribute if backend is a Hash" do
      resource.backend("name" => "carp", "other" => "stuff")

      expect(resource.backend_name).to eq("carp")
    end
  end

  describe "#backend_attributes" do

    it "returns an empty hash is backend is a String" do
      resource.backend("nadda")

      expect(resource.backend_attributes).to eq(Hash.new)
    end

    it "returns a Hash without the name attribute if backend is a Hash" do
      resource.backend("name" => "derr", "stuff" => "junk")

      expect(resource.backend_attributes).to eq("stuff" => "junk")
    end
  end
end
