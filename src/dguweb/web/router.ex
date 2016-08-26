defmodule DGUWeb.Router do
  use DGUWeb.Web, :router

  alias DGUWeb.Plugs.Authentication

  pipeline :browser do
    plug :accepts, ["html", "json"]
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

    resources "/publisher", PublisherController
    resources "/theme", ThemeController
    resources "/dataset", DatasetController
    resources "/session", SessionController, only: [:new, :create]
    resources "/upload", UploadController, only: [:new, :create, :show]
    post "/upload/:id/put", UploadController, :put
    get "/upload/:id/find", UploadController, :find

    get "/download/:path",  DownloadController, :download

    get    "/login",  SessionController, :login_view
    post   "/login",  SessionController, :login
    get "/logout", SessionController, :logout
    get "/user", UserController, :index

    get "/fakecsv", DatasetController, :fakecsv
  end

end
