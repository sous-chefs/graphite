require "spec_helper"
load_resource("graphite", "web_config")
load_provider("graphite", "web_config")
require_relative "../../libraries/chef_graphite_python"

describe Chef::Provider::GraphiteWebConfig do

  let(:resource_name) { "/them/settings.py" }

  it "is whyrun support" do
    expect(provider).to be_whyrun_supported
  end

  shared_examples "manages file" do

    let(:resource) { provider.manage_file(resource_action) }

    it "sets a default action" do
      expect(resource.action).to eq([resource_action])
    end

    it "sets path from path attribute" do
      new_resource.path("/wat/wat")

      expect(resource.path).to eq("/wat/wat")
    end
  end

  context "for :create action" do

    let(:action) { :create }
    before { new_resource.action(action) }

    describe "#manage_file" do

      let(:resource_action) { :create }
      let(:content) { resource.manage_file(resource_action).content }

      include_examples "manages file"

      it "inserts a header" do
        expect(content).to match(regexify_line(
                                   "# This file is managed by Chef, your changes *will* be overwritten!"
        ))
      end

      it "adds the config as Python code" do
        new_resource.config(the_key: true)

        expect(content).to match(regexify_line("THE_KEY = True"))
      end

      it "adds the optimistic code loading code" do
        expect(content).to match(regexify_line("except ImportError:"))
      end
    end

    it "adds the file to the resource collection" do
      provider.run_action(action)

      expect(runner_resources).to include("file[/them/settings.py]")
    end
  end

  context "for :delete action" do

    let(:action) { :delete }
    before { new_resource.action(action) }

    describe "#manage_file" do

      let(:resource_action) { :delete }

      include_examples "manages file"
    end

    it "adds the file to the resource collection" do
      provider.run_action(action)

      expect(runner_resources).to include("file[/them/settings.py]")
    end
  end

  describe "#dynamic_template_name" do

    it "strips .py extension off dynamic_template" do
      new_resource.dynamic_template("kermit.py")

      expect(provider.dynamic_template_name).to eq("kermit")
    end

    it "preserves dynamic_template with a non .py extension" do
      new_resource.dynamic_template("miss_piggy.txt")

      expect(provider.dynamic_template_name).to eq("miss_piggy.txt")
    end
  end

  describe "#optimistic_loader_code" do

    it "adds python code for optimistic loading" do
      new_resource.dynamic_template("kermit.py")

      expect(provider.optimistic_loader_code).to eq(<<-PYTHON.gsub(/^ {8}/, ''))

        try:
          from graphite.kermit import *
        except ImportError:
          pass

      PYTHON
    end
  end

  def regexify_line(string)
    Regexp.new("^#{Regexp.escape(string)}$")
  end
end
