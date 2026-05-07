# frozen_string_literal: true

require 'spec_helper'

describe 'graphite_service' do
  step_into :graphite_service
  platform 'ubuntu', '24.04'

  recipe do
    graphite_service 'cache'
  end

  it { is_expected.to create_systemd_unit('carbon-cache.service') }
  it { is_expected.to enable_service('carbon-cache') }
  it { is_expected.to start_service('carbon-cache') }
end
