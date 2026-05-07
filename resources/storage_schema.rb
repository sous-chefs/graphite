# frozen_string_literal: true

provides :graphite_storage_schema
unified_mode true

property :config, Hash, default: {}

default_action :create

action :create do
end

action :delete do
end
