require 'spec_helper'

describe 'graphite::_web_packages' do
  context 'on centos' do
    before do
      stub_command('sestatus | grep enabled').and_return(true)
    end

    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'centos', version: '7'
      ).converge('graphite::web', described_recipe)
    end

    it 'installs a django python package' do
      expect(chef_run).to install_python_package('django')
    end

    it 'installs a specific version of graphite_web python package' do
      expect(chef_run).to install_python_package('graphite_web').with(
        package_name: 'graphite-web',
        version: '1.1.3'
      )
    end
  end
end
