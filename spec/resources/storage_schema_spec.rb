require 'spec_helper'
load_resource('graphite', 'storage_schema')

describe Chef::Resource::GraphiteStorageSchema do
  let(:resource_name) { 'theone' }

  it 'sets the name attribute to name' do
    expect(resource.name).to eq('theone')
  end

  it 'attribute config defaults to nil' do
    expect(resource.config).to be_nil
  end

  it 'attribute config takes a Hash value' do
    resource.config('a' => 'b')

    expect(resource.config).to eq('a' => 'b')
  end

  it 'action defaults to :create' do
    expect(resource.action).to eq(:create)
  end

  it 'actions include :delete' do
    expect(resource.allowed_actions).to include(:delete)
  end
end
