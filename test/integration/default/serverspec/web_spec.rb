require_relative "./spec_helper"

describe "Graphite webapp" do

  it "is listening on port 80" do
    expect(port(80)).to be_listening
  end

  it "is should serve the graphite browser" do
    expect(command("wget -qO- localhost")).to return_stdout(/Graphite Browser/)
  end

end
