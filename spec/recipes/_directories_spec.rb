require 'spec_helper'

describe 'graphite::_directories' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }
  let(:storage) { '/opt/graphite/storage' }

  it 'creates the graphite storage directory' do
    expect(chef_run).to create_directory(storage).with(
      user: 'graphite',
      group: 'graphite',
      recursive: true
    )
  end

  %w( log whisper rrd).each do |dir|
    it "creates the graphite storage subdirectory #{dir}" do
      expect(chef_run).to create_directory(File.join(storage, dir)).with(
        user: 'graphite',
        group: 'graphite',
        recursive: true
      )
    end
  end
end
