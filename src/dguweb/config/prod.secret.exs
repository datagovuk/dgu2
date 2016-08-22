use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :dguweb, DGUWeb.Endpoint,
  secret_key_base: "U28NhDPtq3piAYGOkQ6xufnsXY4X2ozzCf+ZUJqqDujEtkZIPvS0TnLCBcxjFZYF"

# Configure your database
config :dguweb, DGUWeb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "dguweb_prod",
  pool_size: 20

config :tirexs, :uri, "http://127.0.0.1:9200"
config :dguweb, index: "dgu"
config :dguweb, upload_path: "/mnt/uploads", host: "http://dguproto1.northeurope.cloudapp.azure.com"
