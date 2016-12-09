require 'spec_helper'
load_resource('graphite', 'carbon_aggregator')

describe Chef::Resource::GraphiteCarbonAggregator do
  let(:resource_name) { 'echo' }

  it 'sets the default attribute to name' do
    expect(resource.name).to eq('echo')
  end

  it 'attribute config defaults to nil' do
    expect(resource.config).to be_nil
  end

  it 'attribute config takes a Hash value' do
    resource.config('a' => 'metaphor')

    expect(resource.config).to eq('a' => 'metaphor')
  end

  it 'action defaults to :create' do
    expect(resource.action).to eq([:create])
  end

  it 'actions include :delete' do
    expect(resource.allowed_actions).to include(:delete)
  end
end
