require 'rspec'
require_relative '../../libraries/chef_graphite_ini_writer'

describe ChefGraphite do

  describe ".generate_conf_data" do

    let(:input) do
      [
        { type: "beta", name: "b", config: { "A_KEY" => [true, "#.blah", 4] } },
        { type: "alpha", name: "a", config: { :another_key => "something" } },
        { type: "beta", name: "default", config: { "is_frog" => true } }
      ]
    end

    it "returns an empty hash if an empty array is given" do
      expect(ChefGraphite.generate_conf_data([])).to eq({})
    end

    it "returns section keys sorted alphabetically" do
      input = [
        { type: "beta", name: "b", config: {} },
        { type: "alpha", name: "a", config: {} },
        { type: "beta", name: "g", config: {} }
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
        { type: "beta", name: "b", config: { "A_KEY" => [true, "#.blah", 4] } },
        { type: "alpha", name: "a", config: { :another_key => "something" } },
        { type: "beta", name: "default", config: { "is_frog" => true } }
      ]
    end

    it "returns an empty file with comment for an empty array of resources" do
      expect(ChefGraphite.ini_file([])).to eq("\n")
    end

    it "returns the ini format as a string" do
      expect(ChefGraphite.ini_file(resources)).to eq(<<-INI)
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
