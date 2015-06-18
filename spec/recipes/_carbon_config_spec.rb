require 'spec_helper'

describe 'graphite::_carbon_config' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  let(:file_resource) { chef_run.find_resource(:template, "carbon.conf") }

  context "for the file resource" do

    it "has the path specified" do
      expect(file_resource.path).to eq('/opt/graphite/conf/carbon.conf')
    end

    it "has the correct owner" do
      expect(file_resource.owner).to eq('graphite')
    end

    it "has the correct group" do
      expect(file_resource.group).to eq('graphite')
    end

    it "has correct mode" do
      expect(file_resource.mode).to eq(0644)
    end

    it "has action :create" do
      expect(file_resource.performed_actions).to eq([:create])
    end

  end

  it "to create the graphite_carbon_conf_accumulator resource" do
    expect(chef_run).to create_graphite_carbon_conf_accumulator("default")
  end

end
