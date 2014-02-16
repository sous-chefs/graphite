require_relative "./spec_helper"

describe "Whisper Database" do

  it "has python whisper module" do
    expect(command("python -c'import whisper'")).to return_exit_status 0
  end

  it "has whisper storage path" do
    expect(file("/opt/graphite/storage/whisper")).to be_directory
  end

  it "ensures whisper distribution scripts are executable" do
    %w{create dump fetch info merge resize set-aggregation-method update}.each do |cmd|
      expect(command("whisper-#{cmd}.py -h")).to return_exit_status 0
    end
  end

end
