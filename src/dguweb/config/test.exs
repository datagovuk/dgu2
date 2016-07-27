use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dguweb, DGUWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :dguweb, DGUWeb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "dgu",
  password: "pass",
  database: "dguweb_test",
  hostname: "192.168.100.100",
  pool: Ecto.Adapters.SQL.Sandbox
