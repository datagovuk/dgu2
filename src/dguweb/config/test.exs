use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dguweb, DGUWeb.Endpoint,
  http: [port: 4001],
  server: false

config :tirexs, :uri, System.get_env("ELASTIC_URI") || "http://192.168.100.100:9200"
config :dguweb, DGUWeb.Repo,
    index: "dgu_test"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :dguweb, DGUWeb.EctoRepo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_POSTGRESQL_USERNAME") || "dgu",
  password: System.get_env("DATABASE_POSTGRESQL_PASSWORD") || "pass",
  database: "dguweb_test",
  hostname: System.get_env("DB_HOST") || "192.168.100.100",
  pool: Ecto.Adapters.SQL.Sandbox

# Reduce rounds for bcrypt during tests
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1
