require 'spec_helper'

describe 'graphite_storage resource' do
  let(:chef_run) do
    ChefSpec::Runner.new { |node|
      node.set['graphite']['version'] = '99.88.77'
    }.converge("graphite_storage::#{action}")
  end

  describe "with the create action" do
    let(:action) { "create" }

    it 'sets a version of storage' do
      expect(chef_run).to create_graphite_storage('/opt/graphite/storage').
        with(version: '99.88.77')
    end

    it 'sets a custom package name' do
      expect(chef_run).to create_graphite_storage('instance-2').
        with(prefix: '/tmp/goodstuff', package_name: 'https://example.com/pkg.tgz')
    end
  end

  describe "with the delete action" do
    let(:action) { "delete" }

    it 'removes a graphite storage path' do
      expect(chef_run).to delete_graphite_storage('instance-1').
        with(prefix: '/mnt/graphin/stuff')
    end
  end
end
