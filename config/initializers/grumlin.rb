# frozen_string_literal: true

Grumlin.configure do |config|
  config.url = ENV.fetch("DATABASE_URL", "ws://localhost:8182/gremlin")

  # make sure you select right provider for better compatibility
  config.provider = :tinkergraph
end
