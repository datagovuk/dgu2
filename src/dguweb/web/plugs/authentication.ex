defmodule DGUWeb.Plugs.Authentication do
  import Plug.Conn
  import Phoenix.Controller

  alias DGUWeb.Repo
  alias DGUWeb.User

  def init(default), do: default

  def call(conn, default) do
    current_user = get_session(conn, :current_user)
    if current_user do
      user = Repo.get!(User, current_user)
      publishers = user |> User.publishers

      conn
      |> assign(:current_user, user)
      |> assign(:user_publishers, publishers)
    else
      conn
    end

  end
end