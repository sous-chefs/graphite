# frozen_string_literal: true

require 'spec_helper'

describe 'graphite_storage_config' do
  step_into :graphite_storage_config
  platform 'ubuntu', '24.04'

  recipe do
    graphite_storage_schema 'default' do
      config(pattern: '.*', retentions: '60s:1d')
    end

    graphite_storage_config 'default'
  end

  it { is_expected.to create_file('/opt/graphite/conf/storage-schemas.conf').with(owner: 'graphite', group: 'graphite', mode: '0644') }
  it { is_expected.to render_file('/opt/graphite/conf/storage-schemas.conf').with_content(/\[default\]/) }
  it { is_expected.to render_file('/opt/graphite/conf/storage-schemas.conf').with_content(/RETENTIONS = 60s:1d/) }
end
