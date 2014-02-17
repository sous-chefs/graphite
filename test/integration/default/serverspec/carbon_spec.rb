require_relative "./spec_helper"

describe "Carbon listener" do

  it "has a running carbon-cache.py python process" do
    expect(process("python")).to be_running
  end

  it "is listening on line reciever port 2003" do
    expect(port(2003)).to be_listening
  end

  it "is listening on pickle reciever port 2004" do
    expect(port(2004)).to be_listening
  end

  it "is listening on cache query port 7002" do
    expect(port(2003)).to be_listening
  end

end
