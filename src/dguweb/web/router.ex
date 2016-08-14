defmodule DGUWeb.Router do
  use DGUWeb.Web, :router
  use ExAdmin.Router

  alias DGUWeb.Plugs.Authentication

  scope "/admin", ExAdmin do
    pipe_through :browser
    admin_routes
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    #plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Authentication
  end

  scope "/", DGUWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/search", SearchController, :search

    get "/publish", PublishController, :index
    post "/publish", PublishController, :add_file
    get "/publish/find", PublishController, :find

    resources "/publisher", PublisherController
    resources "/theme", ThemeController
    resources "/dataset", DatasetController

    resources "/session", SessionController, only: [:new, :create]
    get    "/login",  SessionController, :login_view
    post   "/login",  SessionController, :login
    get "/logout", SessionController, :logout
    get "/user", UserController, :index

    get "/fakecsv", DatasetController, :fakecsv
  end


  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", DGUWeb do
  #   pipe_through :api
  # end
end
