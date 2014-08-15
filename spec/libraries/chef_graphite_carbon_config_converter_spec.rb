require 'rspec'
require_relative '../../libraries/chef_graphite_carbon_config_converter'

describe ChefGraphite::CarbonConfigConverter do
  let(:config) { Array.new }

  let(:converter) { ChefGraphite::CarbonConfigConverter.new(config) }

  describe "#to_hash" do
    it "takes a nil config has and returns an empty hash" do
      expect(ChefGraphite::CarbonConfigConverter.new(nil).to_hash).to eq(Hash.new)
    end

    it "takes an empty config array and returns an empty hash" do
      expect(converter.to_hash).to eq(Hash.new)
    end

    it "returns section keys sorted alphabetically" do
      config.concat([
        { type: "beta", name: "b", config: {} },
        { type: "alpha", name: "a", config: {} },
        { type: "beta", name: "g", config: {} }
      ])

      expect(converter.to_hash.keys).to eq(["alpha:a", "beta:b", "beta:g"])
    end

    it "remove section keys named 'default'" do
      config.concat([
        { type: "beta", name: "b", config: {} },
        { type: "alpha", name: "a", config: {} },
        { type: "beta", name: "default", config: {} }
      ])

      expect(converter.to_hash.keys).to eq(["alpha:a", "beta", "beta:b"])
    end

    context "for config" do

      let(:config) do
        [
          { type: "beta", name: "b", config: { "A_KEY" => [true, "#.blah", 4] } },
          { type: "alpha", name: "a", config: { :another_key => "something" } },
          { type: "beta", name: "default", config: { "is_frog" => true } }
        ]
      end

      it "normalizes string key names to uppercase" do
        expect(converter.to_hash["beta"].keys).to eq(["IS_FROG"])
      end

      it "normalizes symbol key names to uppercase" do
        expect(converter.to_hash["alpha:a"].keys).to eq(["ANOTHER_KEY"])
      end

      it "normalizes ruby boolean values to capitalized strings" do
        expect(converter.to_hash["beta"]["IS_FROG"]).to eq("True")
      end

      it "normalizes ruby array elements to strings" do
        expect(converter.to_hash["beta:b"]["A_KEY"]).to eq("True, #.blah, 4")
      end
    end
  end
end
