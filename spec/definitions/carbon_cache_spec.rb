require 'spec_helper'

describe 'graphite_carbon_cache (definition)' do
  let(:recipe_run) do
    fake_recipe_run do
      graphite_carbon_cache 'default' do
        config(
          enable_logrotation: true,
          user: 'graphite',
          line_receiver_port: 2003,
          udp_receiver_port: 2003,
          pickle_receiver_port: 2004,
          cache_query_port: 7002
        )
      end

      graphite_carbon_cache 'a' do
        config(
          line_receiver_port: 2004,
          udp_receiver_port: 2004,
          pickle_receiver_port: 2005,
          cache_query_port: 7003
        )
      end
    end
  end

  it 'creates default carbon-cache configuration' do
    expect(recipe_run).to render_file('carbon.conf')
      .with_content([
        '[cache]',
        'ENABLE_LOGROTATION = True',
        'USER = graphite',
        'LINE_RECEIVER_PORT = 2003',
        'UDP_RECEIVER_PORT = 2003',
        'PICKLE_RECEIVER_PORT = 2004',
        'CACHE_QUERY_PORT = 7002'
      ].join("\n"))
  end

  it 'creates named carbon-cache configuration' do
    expect(recipe_run).to render_file('carbon.conf')
      .with_content([
        '[cache:a]',
        'LINE_RECEIVER_PORT = 2004',
        'UDP_RECEIVER_PORT = 2004',
        'PICKLE_RECEIVER_PORT = 2005',
        'CACHE_QUERY_PORT = 7003'
      ].join("\n"))
  end
end
