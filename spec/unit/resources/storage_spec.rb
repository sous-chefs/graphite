# frozen_string_literal: true

require 'spec_helper'

describe 'graphite_storage' do
  step_into :graphite_storage
  platform 'ubuntu', '24.04'

  recipe do
    graphite_storage '/opt/graphite/storage'
  end

  it { is_expected.to create_directory('/opt/graphite/storage') }
  it { is_expected.to install_package('python3-whisper') }
end
