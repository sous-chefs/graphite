# frozen_string_literal: true

require 'spec_helper'

describe 'graphite_carbon_config' do
  step_into :graphite_carbon_config
  platform 'ubuntu', '24.04'

  recipe do
    graphite_carbon_cache 'default' do
      config(line_receiver_port: 2003)
    end

    graphite_carbon_relay 'edge' do
      config(line_receiver_port: 2013)
    end

    graphite_carbon_config 'default'
  end

  it { is_expected.to create_directory('/opt/graphite/conf') }
  it { is_expected.to create_file('/opt/graphite/conf/carbon.conf').with(owner: 'graphite', group: 'graphite', mode: '0644') }
  it { is_expected.to render_file('/opt/graphite/conf/carbon.conf').with_content(/\[cache\]/) }
  it { is_expected.to render_file('/opt/graphite/conf/carbon.conf').with_content(/LINE_RECEIVER_PORT = 2003/) }
  it { is_expected.to render_file('/opt/graphite/conf/carbon.conf').with_content(/\[relay:edge\]/) }
end
