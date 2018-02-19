require 'rspec'
require_relative '../../libraries/chef_graphite_ini_writer'

describe ChefGraphite::INIWriter do
  let(:config) { {} }
  let(:writer) { ChefGraphite::INIWriter.new(config) }

  describe '#to_s' do
    it 'takes a nil config has and returns an empty string' do
      expect(ChefGraphite::INIWriter.new(nil).to_s).to eq("\n")
    end

    it 'takes an empty config hash and returns an empty string' do
      expect(writer.to_s).to eq("\n")
    end

    it 'maps a top level key in the config to an INI section' do
      config['asection'] = {}

      expect(writer.to_s).to eq("[asection]\n")
    end

    it "renders the section's subhash as key/value pairs" do
      config['alpha'] = {
        'one' => 'two',
        'three' => 'four',
      }

      expect(writer.to_s).to eq(<<-EOF.gsub(/^\s+/, ''))
        [alpha]
        one = two
        three = four

      EOF
    end

    it 'handles multiple INI sections and key/value pairs' do
      config['alpha'] = {
        'one' => 'two',
        'three' => 'four',
      }
      config['beta'] = {
        'apple' => 'orange',
        'pear' => 'kiwi',
      }

      expect(writer.to_s).to eq(<<-EOF.gsub(/^\s+/, ''))
        [alpha]
        one = two
        three = four

        [beta]
        apple = orange
        pear = kiwi

      EOF
    end
  end
end
