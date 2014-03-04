include_recipe "graphite::carbon"

graphite_carbon_cache "default" do
  config ({
      enable_logrotation: true,
      user: nil,
      max_cache_size: "inf",
      max_updates_per_second: 500,
      max_creates_per_minute: 50,
      line_receiver_interface: "0.0.0.0",
      line_receiver_port: 2003,
      enable_udp_listener: false,
      cache_query_port: "7002",
      cache_write_strategy: "sorted"
    })
end

graphite_carbon_cache "a" do
  config ({
      user: "graphite",
      line_receiver_port: 2004,
      udp_receiver_port: 2004,
      pickle_receiver_port: 2004,
      cache_query_port: 7003,
      use_flow_control: true,
      log_updates: false,
      log_cache_hits: false,
      whisper_autoflush: false
    })
end
