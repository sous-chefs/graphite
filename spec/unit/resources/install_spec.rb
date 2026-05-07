# frozen_string_literal: true

require 'spec_helper'

describe 'graphite_install' do
  step_into :graphite_install
  platform 'ubuntu', '24.04'

  context 'with platform packages' do
    recipe do
      graphite_install 'default'
    end

    it { is_expected.to create_group('graphite') }
    it { is_expected.to create_user('graphite') }
    it { is_expected.to create_directory('/opt/graphite') }
    it { is_expected.to install_package(%w(python3-venv python3-dev libcairo2-dev libffi-dev build-essential python3-rrdtool)) }
    it { is_expected.to install_package(%w(python3-whisper graphite-carbon graphite-web)) }
  end
end
