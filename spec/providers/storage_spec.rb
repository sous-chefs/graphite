require 'spec_helper'
load_resource("graphite", "storage")
load_provider("graphite", "storage")

describe Chef::Provider::GraphiteStorage do

  before { using_lw_resource("python", "pip") }

  let(:resource_name) { "/path/to/greatness" }

  it "is whyrun supported" do
    expect(provider).to be_whyrun_supported
  end

  shared_examples "manages python_pip" do

    let(:resource) { provider.manage_python_pip(resource_action) }

    it "sets a default action" do
      expect(resource.action).to eq([resource_action])
    end

    it "defaults name to whisper" do
      expect(resource.package_name).to eq("whisper")
    end

    it "sets name from package_name attribute" do
      new_resource.package_name("complain")

      expect(resource.package_name).to eq("complain")
    end

    it "defaults version to nil" do
      expect(resource.version).to be_nil
    end

    it "sets version from version attribute" do
      new_resource.version("1.2.3")

      expect(resource.version).to eq("1.2.3")
    end
  end

  shared_examples "manages directory" do

    let(:resource) { provider.manage_directory(resource_action) }

    it "sets action to :create" do
      expect(resource.action).to eq([resource_action])
    end

    it "sets path to prefix attribute" do
      resource.path("yep")

      expect(resource.path).to eq("yep")
    end

    it "sets recursive to true" do
      expect(resource.recursive).to be_true
    end
  end

  shared_examples "resource collection" do

    it "adds python_pip to the resource collection" do
      provider.run_action(action)

      expect(runner_resources).to include("python_pip[whisper]")
    end

    it "adds directory to the resource collection" do
      provider.run_action(action)

      expect(runner_resources).to include("directory[/path/to/greatness]")
    end
  end

  context "for :create action" do

    let(:action) { :create }

    before { new_resource.action(action) }

    describe "#manage_python_pip" do

      let(:resource_action) { :install }

      include_examples "manages python_pip"
    end

    describe "#manage_directory" do

      let(:resource_action) { :create }

      include_examples "manages directory"
    end

    include_examples "resource collection"
  end

  context "for :delete action" do

    let(:action) { :delete }

    before { new_resource.action(action) }

    describe "#manage_python_pip" do

      let(:resource_action) { :remove }

      include_examples "manages python_pip"
    end

    describe "#manage_directory" do

      let(:resource_action) { :delete }

      include_examples "manages directory"
    end

    include_examples "resource collection"
  end
end
