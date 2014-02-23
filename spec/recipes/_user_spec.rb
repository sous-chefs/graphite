require 'spec_helper'

describe 'graphite::_user' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it "creates the graphite group" do
    expect(chef_run).to create_group('graphite')
  end

  it "creates the graphite user" do
    expect(chef_run).to create_user('graphite').with(
      group: 'graphite',
      home: '/var/lib/graphite',
      shell: '/bin/false'
    )
  end

end
