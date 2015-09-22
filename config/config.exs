# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :handiman_api, HandimanApi.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "sQ0nQLOonxnxnyUZktB05I/9PoHPZQvsUA/anM0Q0B5v04a/zj2kI8aEV4OlX7SM",
  render_errors: [default_format: "html"],
  pubsub: [name: HandimanApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :joken, config_module: Guardian.JWT

config :guardian, Guardian,
  issuer: "HandimanApi",
  ttl: { 2, :hours },
  verify_issuer: true,
  secret_key: "sQ0nQLOonxnxnyUZktB05I/9PoHPZQvsUA/anM0Q0B5v04a/zj2kI8aEV4OlX7SM",
  serializer: HandimanApi.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
