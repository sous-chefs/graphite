require 'rspec'
require_relative '../../libraries/mixins'

describe ChefGraphite::Mixins do
  include ChefGraphite::Mixins

  describe '.resources_to_hashes' do
    let(:resources) do
      [
        double(name: 'a', resource_name: :bleh_blah, config: { one: 'two' }),
        double(name: 'b', resource_name: :wakka, config: { alpha: 'beta' }),
      ]
    end

    let(:whitelist) { [:bleh_blah, :wakka] }

    it 'returns an empty array if an empty array of resources is given' do
      expect(resources_to_hashes([])).to eq([])
    end

    it 'returns an empty array if nil is given' do
      expect(resources_to_hashes(nil)).to eq([])
    end

    it 'returns an array of hashes with types set given a whitelist' do
      expect(resources_to_hashes(resources, whitelist)).to eq([
                                                                { type: 'blah', name: 'a', config: { one: 'two' } },
                                                                { type: 'wakka', name: 'b', config: { alpha: 'beta' } },
                                                              ])
    end

    it 'returns an array of hashes with nil types when no whitelist is given' do
      expect(resources_to_hashes(resources)).to eq([
                                                     { type: nil, name: 'a', config: { one: 'two' } },
                                                     { type: nil, name: 'b', config: { alpha: 'beta' } },
                                                   ])
    end
  end
end
