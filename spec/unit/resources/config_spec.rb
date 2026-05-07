# frozen_string_literal: true

require 'spec_helper'

describe 'graphite_config' do
  step_into :graphite_config
  platform 'ubuntu', '24.04'

  recipe do
    graphite_config 'default'
  end

  it { is_expected.to create_directory('/opt/graphite/conf') }
  it { is_expected.to create_directory('/opt/graphite/storage') }
  it { is_expected.to create_directory('/opt/graphite/storage/log') }
  it { is_expected.to create_template('/opt/graphite/conf/graphTemplates.conf') }
end
