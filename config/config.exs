# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

config :nobinalo_api,
  ecto_repos: [Nobinalo.Repo],
  generators: [context_app: :nobinalo]

# Configures the endpoint
config :nobinalo_api, NobinaloApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ABu1SSTewgBWkrZzJz+pCOwNHv7Y3hM5thsm6fN27QdUlxL1SvlH4P8l6a49S5CW",
  render_errors: [view: NobinaloApi.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: NobinaloApi.PubSub,
  live_view: [signing_salt: "MzQnjqLS"]

# Configure Mix tasks and generators
config :nobinalo,
  ecto_repos: [Nobinalo.Repo]

# gaurdian config for email verification token
config :nobinalo, Nobinalo.Users.Emails.Guardian,
  issuer: "nobinalo",
  verify_issuer: true,
  secret_key: "4MxAx7D/a8sURTzv+/jkhUaq1sZyDxEjyxlqJDWsAXyUoAuGqHgzS4TVe6q2NevE"

config :nobinalo_web,
  ecto_repos: [Nobinalo.Repo],
  generators: [context_app: :nobinalo]

# Configures the endpoint
config :nobinalo_web, NobinaloWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xeunoTfiMCJPckJLlb7pZNVHHlDgRRfpJ1LGJAEuhHBN3IbUOqnBeGoGFsVB+pcD",
  render_errors: [view: NobinaloWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Nobinalo.PubSub,
  live_view: [signing_salt: "NjTpCwT0"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
