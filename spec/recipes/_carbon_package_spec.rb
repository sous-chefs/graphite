require 'spec_helper'

describe 'graphite::carbon' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'installs python runtime' do
    expect(chef_run).to install_graphite_python('carbons_python')
  end
end
