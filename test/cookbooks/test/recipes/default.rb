# frozen_string_literal: true

apt_update 'update' if platform_family?('debian')

graphite_install 'default' do
  base_dir '/opt/graphite'
  storage_dir '/opt/graphite/storage'
end

graphite_config 'default'

graphite_carbon_cache 'default' do
  config(
    enable_logrotation: true,
    user: 'graphite',
    max_cache_size: 'inf',
    max_updates_per_second: 500,
    max_creates_per_minute: 50,
    line_receiver_interface: '0.0.0.0',
    line_receiver_port: 2003,
    udp_receiver_port: 2003,
    pickle_receiver_port: 2004,
    enable_udp_listener: true,
    cache_query_port: 7002,
    cache_write_strategy: 'sorted',
    use_flow_control: true,
    log_updates: false,
    log_cache_hits: false,
    whisper_autoflush: false,
    local_data_dir: '/opt/graphite/storage/whisper/'
  )
end

graphite_storage_schema 'carbon' do
  config(
    pattern: '^carbon.',
    retentions: '60:90d'
  )
end

graphite_storage_schema 'default_1min_for_1day' do
  config(
    pattern: '.*',
    retentions: '60s:1d'
  )
end

graphite_carbon_config 'default' do
  caches [
    {
      name: 'default',
      config: {
        enable_logrotation: true,
        user: 'graphite',
        max_cache_size: 'inf',
        max_updates_per_second: 500,
        max_creates_per_minute: 50,
        line_receiver_interface: '0.0.0.0',
        line_receiver_port: 2003,
        udp_receiver_port: 2003,
        pickle_receiver_port: 2004,
        enable_udp_listener: true,
        cache_query_port: 7002,
        cache_write_strategy: 'sorted',
        use_flow_control: true,
        log_updates: false,
        log_cache_hits: false,
        whisper_autoflush: false,
        local_data_dir: '/opt/graphite/storage/whisper/',
      },
    },
  ]
end

graphite_storage_config 'default' do
  schemas [
    { name: 'carbon', config: { pattern: '^carbon.', retentions: '60:90d' } },
    { name: 'default_1min_for_1day', config: { pattern: '.*', retentions: '60s:1d' } },
  ]
end
graphite_service 'cache'
