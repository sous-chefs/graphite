require_relative '../spec_helper'
load_resource('graphite', 'carbon_relay')
load_provider('graphite', 'carbon_relay')

describe Chef::Provider::GraphiteCarbonRelay do
  let(:resource_name) { 'betta' }

  it 'is whyrun support' do
    expect(provider).to be_whyrun_supported
  end

  it 'for :create action, it exists' do
    expect(provider.run_action(:create))
  end

  it 'for :delete action, it exists' do
    expect(provider.run_action(:delete))
  end
end
