use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :nobinalo_api, NobinaloApi.Endpoint,
  http: [port: 4002],
  server: false

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :nobinalo, Nobinalo.Repo,
  username: "postgres",
  password: "postgres",
  database: "nobinalo_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :nobinalo_web, NobinaloWeb.Endpoint,
  http: [port: 4002],
  server: false

config :nobinalo, Nobinalo.Users.Emails.Mailer, adapter: Bamboo.TestAdapter

# Print only warnings and errors during test
config :logger, level: :warn

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
