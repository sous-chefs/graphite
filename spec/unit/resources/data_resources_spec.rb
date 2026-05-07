# frozen_string_literal: true

require 'spec_helper'

describe 'graphite data resources' do
  platform 'ubuntu', '24.04'

  recipe do
    graphite_carbon_cache 'default'
    graphite_carbon_relay 'default'
    graphite_carbon_aggregator 'default'
    graphite_storage_schema 'default'
  end

  it { is_expected.to create_graphite_carbon_cache('default') }
  it { is_expected.to create_graphite_carbon_relay('default') }
  it { is_expected.to create_graphite_carbon_aggregator('default') }
  it { is_expected.to create_graphite_storage_schema('default') }
end
