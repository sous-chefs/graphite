# frozen_string_literal: true

provides :graphite_carbon_cache
unified_mode true

property :backend, [String, Hash], default: 'whisper'
property :config, Hash, default: {}

default_action :create

action :create do
end

action :delete do
end
