# frozen_string_literal: true

require 'spec_helper'

describe 'graphite_web_config' do
  step_into :graphite_web_config
  platform 'ubuntu', '24.04'

  recipe do
    graphite_web_config '/opt/graphite/webapp/graphite/local_settings.py' do
      config(secret_key: 'secret', time_zone: 'UTC')
    end
  end

  it { is_expected.to create_file('/opt/graphite/webapp/graphite/local_settings.py') }
  it { is_expected.to render_file('/opt/graphite/webapp/graphite/local_settings.py').with_content(/SECRET_KEY = 'secret'/) }
end
