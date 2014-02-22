require 'spec_helper'

describe 'graphite_storage provider' do

  let(:chef_run) do
    ChefSpec::Runner.new(step_into: ['graphite_storage']) { |node|
      node.set['graphite']['version'] = '0.0.999'
    }.converge("graphite_storage::#{action}")
  end

  describe "with the create action" do
    let(:action) { "create" }

    it 'installs a specific version of whisper from pip' do
      expect(chef_run).to install_python_pip('whisper').
        with(version: '0.0.999')
    end

    it 'installs a custom tarball from a URL' do
      expect(chef_run).to install_python_pip('https://example.com/pkg.tgz').
        with(version: nil)
    end

    it 'creates a directory with the default action' do
      expect(chef_run).to create_directory('/opt/graphite/storage')
    end

    it 'creates a directory when path is given as an attribute' do
      expect(chef_run).to create_directory('/tmp/goodstuff')
    end

  end

  describe "with the delete action" do
    let(:action) { "delete" }

    it 'removes a graphite storage library' do
      expect(chef_run).to remove_python_pip('whisper')
    end

    it 'removes a graphite storage path' do
      expect(chef_run).to delete_directory("/mnt/graphin/stuff")
      expect(chef_run).to_not delete_directory("/mnt/graphin/")
    end

  end
end
