require 'spec_helper'

describe "graphite::carbon" do
  let(:runner) do
    ChefSpec::Runner.new { |node| node.automatic["platform_family"] = "debian" }
  end
  let(:node) { runner.node }
  let(:chef_run) { runner.converge(described_recipe) }

  it "includes build-essential for python_pip usage" do
    expect(chef_run).to include_recipe("build-essential")
  end

  it "installs python Twisted package" do
    expect(chef_run).to install_python_pip("Twisted")
  end

  it "installs python Twisted pinned to a version" do
    node.set["graphite"]["twisted_version"] = "foobar.fuzzy.pants"
    expect(chef_run).to install_python_pip("Twisted").
      with(version: "foobar.fuzzy.pants")
  end

  context "install type package" do
    before do
      node.set["graphite"]["version"] = "99"
      node.set["graphite"]["install_type"] = "package"
    end

    it "installs carbon from pypi pinned to a version" do
      expect(chef_run).to install_python_pip("carbon").
        with(version: "99", package_name: "carbon" )
    end

  end

  context "install type source" do
    before do
      node.set["graphite"]["version"] = "99"
      node.set["graphite"]["install_type"] = "source"
    end

    it "installs carbon from a url with no version set" do
      expect(chef_run).to install_python_pip("carbon").
        with(
        version: nil,
        package_name: "https://github.com/graphite-project/graphite-web/zipball/master"
        )
    end

  end

end
