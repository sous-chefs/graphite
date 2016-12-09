require 'spec_helper'
load_resource('graphite', 'storage')

describe Chef::Resource::GraphiteStorage do
  let(:resource_name) { '/opt/barn' }

  it 'sets the default attribute to prefix' do
    expect(resource.prefix).to eq('/opt/barn')
  end

  it 'attribute package_name defaults to whisper' do
    expect(resource.package_name).to eq('whisper')
  end

  it 'attribute package_name takes a String value' do
    resource.package_name('sing')

    expect(resource.package_name).to eq('sing')
  end

  it 'attribute version defaults to nil' do
    expect(resource.version).to be_nil
  end

  it 'attribute version takes a String value' do
    resource.version('99')

    expect(resource.version).to eq('99')
  end

  it 'attribute type defaults to whisper' do
    expect(resource.type).to eq('whisper')
  end

  it 'attribute type takes a String value' do
    resource.type('another')

    expect(resource.type).to eq('another')
  end

  it 'action defaults to :create' do
    expect(resource.action).to eq([:create])
  end

  it 'actions include :delete' do
    expect(resource.allowed_actions).to include(:delete)
  end

  it 'actions include :upgrade' do
    expect(resource.allowed_actions).to include(:upgrade)
  end
end
