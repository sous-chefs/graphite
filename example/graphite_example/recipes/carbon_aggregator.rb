include_recipe "graphite::carbon"

graphite_carbon_aggregator "default" do
  config ({
      line_receiver_interface: "0.0.0.0",
      line_receiver_port: 2005,
      replication_factor: 1,
      use_flow_control: true,
      relay_method: "consistent-hashing",
      destinations: [
        "127.0.0.1:2003:a",
        "127.0.0.1:2004:b"
      ]
    })
end
