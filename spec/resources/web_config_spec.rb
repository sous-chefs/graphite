require 'spec_helper'
load_resource('graphite', 'web_config')

describe Chef::Resource::GraphiteWebConfig do
  let(:resource_name) { '/opt/graphite/file.py' }

  it 'sets the path attribute to name' do
    expect(resource.path).to eq('/opt/graphite/file.py')
  end

  it 'action defaults to :create' do
    expect(resource.action).to eq([:create])
  end

  it 'returns a default dynamic template parameter' do
    expect(resource.dynamic_template).to eq('local_settings_dynamic.py')
  end

  it 'allows a custom dynamic template parameter' do
    resource.dynamic_template('random_water_boa.py')
    expect(resource.dynamic_template).to eq('random_water_boa.py')
  end

  it 'action defaults to :create' do
    expect(resource.action).to eq([:create])
  end

  it 'actions include :delete' do
    expect(resource.allowed_actions).to include(:delete)
  end
end
