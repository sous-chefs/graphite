require 'spec_helper'

describe 'graphite::carbon' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04').converge(described_recipe) }

  # it 'installs python runtime' do
  #   expect(chef_run).to install_python_runtime('carbons_python')
  # end
end
