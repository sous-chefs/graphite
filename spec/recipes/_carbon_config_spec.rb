require 'spec_helper'

describe 'graphite::_carbon_config' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04').converge(described_recipe) }
  let(:file_resource) { chef_run.find_resource(:file, 'carbon.conf') }
  let(:dir_resource) { chef_run.find_resource(:directory, 'conf dir') }

  context 'for the directory resource' do
    # it 'has the path specified' do
    #   expect(dir_resource.path).to eq('/opt/graphite/conf')
    # end

    # it 'has the correct owner' do
    #   expect(dir_resource.owner).to eq('graphite')
    # end

    # it 'has the correct group' do
    #   expect(dir_resource.group).to eq('graphite')
    # end

    # it 'has correct mode' do
    #   expect(dir_resource.mode).to eq('755')
    # end

    # it 'has recursive set' do
    #   expect(dir_resource.recursive).to be true
    # end
  end

  context 'for the file resource' do
    # it 'has the path specified' do
    #   expect(file_resource.path).to eq('/opt/graphite/conf/carbon.conf')
    # end

    # it 'has the correct owner' do
    #   expect(file_resource.owner).to eq('graphite')
    # end

    # it 'has the correct group' do
    #   expect(file_resource.group).to eq('graphite')
    # end

    # it 'has correct mode' do
    #   expect(file_resource.mode).to eq('644')
    # end

    # it 'has action :nothing' do
    #   expect(file_resource.performed_actions).to be_empty
    # end
  end

  # it 'to create the graphite_carbon_conf_accumulator resource' do
  #   expect(chef_run).to create_graphite_carbon_conf_accumulator('default')
  # end
end
