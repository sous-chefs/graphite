require 'spec_helper'

describe 'graphite::carbon' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'installs python runtime' do
    expect(chef_run).to install_pyenv_user_install('carbons_pyenv')
  end
end
