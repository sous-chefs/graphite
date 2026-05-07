# frozen_string_literal: true

require 'spec_helper'

describe 'graphite_web' do
  step_into :graphite_web
  platform 'ubuntu', '24.04'

  before do
    stub_command('sestatus | grep enabled').and_return(false)
  end

  recipe do
    graphite_web 'default'
  end

  it { is_expected.to create_directory('/opt/graphite/storage/log/webapp') }
  it { is_expected.to create_file('/opt/graphite/storage/log/webapp/info.log') }
  it { is_expected.to create_directory('/opt/graphite/webapp/graphite') }
end
