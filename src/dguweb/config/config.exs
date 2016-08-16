# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :dguweb,
  namespace: DGUWeb,
  ecto_repos: [DGUWeb.Repo]

# Configures the endpoint
config :dguweb, DGUWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kywpeztn9EW8TE20IkmkfuQt/25uCFt/LDIomvzTbET1SVWdbjfGjfgSGLP8qHVY",
  render_errors: [view: DGUWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DGUWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_admin,
  repo: DGUWeb.Repo,
  module: DGUWeb,
  modules: [
    DGUWeb.ExAdmin.Dashboard,
    DGUWeb.ExAdmin.Publisher,
    DGUWeb.ExAdmin.Dataset,
    DGUWeb.ExAdmin.DataFile,
  ]

# Where are we storing downloads
config :dguweb, upload_path: "/tmp", host: "http://127.0.0.1:4000"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :xain, :after_callback, {Phoenix.HTML, :raw}

