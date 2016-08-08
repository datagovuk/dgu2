defmodule DGUWeb.Router do
  use DGUWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", DGUWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/search", PageController, :search
    
    get "/publish", PublishController, :index
    post "/publish", PublishController, :add_file
    get "/publish/find", PublishController, :find

    resources "/publisher", PublisherController
    resources "/theme", ThemeController
    resources "/dataset", DatasetController
  end


  pipeline :api do
    plug :accepts, ["json"]
>>>>>>> master
  end

  # Other scopes may use custom stacks.
  # scope "/api", DGUWeb do
  #   pipe_through :api
  # end
end
