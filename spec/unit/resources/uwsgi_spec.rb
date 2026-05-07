# frozen_string_literal: true

require 'spec_helper'

describe 'graphite_uwsgi' do
  step_into :graphite_uwsgi
  platform 'ubuntu', '24.04'

  recipe do
    graphite_uwsgi 'default' do
      listen_http true
      port 8080
    end
  end

  it { is_expected.to create_systemd_unit('graphite-web.socket') }
  it { is_expected.to create_systemd_unit('graphite-web.service') }
  it { is_expected.to enable_service('graphite-web') }
  it { is_expected.to start_service('graphite-web') }
end
