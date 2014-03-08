require 'rspec'
require_relative '../../libraries/chef_graphite'

describe ChefGraphite do

  describe ".resources_to_hashes" do

    let(:resources) do
      [
        double(name: "a", resource_name: :bleh_blah, config: { one: "two" }),
        double(name: "b", resource_name: :wakka, config: { alpha: "beta" })
      ]
    end

    let(:whitelist) { [:bleh_blah, :wakka] }

    it "returns an empty array if an empty array of resources is given" do
      expect(ChefGraphite.resources_to_hashes([])).to eq([])
    end

    it "returns an empty array if nil is given" do
      expect(ChefGraphite.resources_to_hashes(nil)).to eq([])
    end

    it "returns an array of hashes with types set given a whitelist" do
      expect(ChefGraphite.resources_to_hashes(resources, whitelist)).to eq([
          { type: "blah", name: "a", config: { one: "two" }},
          { type: "wakka", name: "b", config: { alpha: "beta" }},
        ])
    end

    it "returns an array of hashes with nil types when no whitelist is given" do
      expect(ChefGraphite.resources_to_hashes(resources)).to eq([
          { type: nil, name: "a", config: { one: "two" }},
          { type: nil, name: "b", config: { alpha: "beta" }},
        ])
    end
  end

  describe ".generate_conf_data" do

    let(:input) do
      [
        { type: "beta", name: "b", config: { "A_KEY" => [ true, "#.blah", 4 ] }}, # 
        { type: "alpha", name: "a", config: { :another_key => "something" }},
        { type: "beta", name: "default", config: { "is_frog" => true }},
      ]
    end

    it "returns an empty hash if an empty array is given" do
      expect(ChefGraphite.generate_conf_data([])).to eq({})
    end

    it "returns section keys sorted alphabetically" do
      input = [
        { type: "beta", name: "b", config: {}},
        { type: "alpha", name: "a", config: {}},
        { type: "beta", name: "g", config: {}},
      ]
      data = ChefGraphite.generate_conf_data(input)

      expect(data.keys).to eq(["alpha:a", "beta:b", "beta:g"])
    end

    it "remove section keys named 'default'" do
      data = ChefGraphite.generate_conf_data(input)

      expect(data.keys).to eq(["alpha:a", "beta", "beta:b"])
    end

    context "for config" do

      it "normalizes string key names to uppercase" do
        data = ChefGraphite.generate_conf_data(input)

        expect(data["beta"].keys).to eq(["IS_FROG"])
      end

      it "normalizes symbol key names to uppercase" do
        data = ChefGraphite.generate_conf_data(input)

        expect(data["alpha:a"].keys).to eq(["ANOTHER_KEY"])
      end

      it "normalizes ruby boolean values to capitalized strings" do
        data = ChefGraphite.generate_conf_data(input)

        expect(data["beta"]["IS_FROG"]).to eq("True")
      end

      it "normalizes ruby array elements to strings" do
        data = ChefGraphite.generate_conf_data(input)

        expect(data["beta:b"]["A_KEY"]).to eq("True, #.blah, 4")
      end
    end
  end

  describe ".section_name" do

    it "returns type and name when provided" do
      expect(ChefGraphite.section_name("foo", "bar")).to eq("foo:bar")
    end

    it "returns only type if name is default" do
      expect(ChefGraphite.section_name("piggy", "default")).to eq("piggy")
    end

    it "returns only name if type is nil" do
      expect(ChefGraphite.section_name(nil, "baz")).to eq("baz")
    end
  end

  describe ".ini_file" do

    let(:resources) do
      [
        double(name: "b", resource_name: "beta", config: { "A_KEY" => [ true, "#.blah", 4 ] }),
        double(name: "a", resource_name: "alpha", config: { :another_key => "something" }),
        double(name: "default", resource_name: "beta", config: { "is_frog" => true }),
      ]
    end

    let(:whitelist) { [:beta, :alpha] }

    it "returns an empty file with comment for an empty array of resources" do
      expect(ChefGraphite.ini_file([])).to eq("\n")
    end

    it "returns the ini format as a string" do
      expect(ChefGraphite.ini_file(resources, whitelist)).to eq(<<-INI)
[alpha:a]
ANOTHER_KEY = something

[beta]
IS_FROG = True

[beta:b]
A_KEY = True, #.blah, 4

      INI
    end
  end
end
