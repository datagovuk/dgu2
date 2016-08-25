defmodule DGUWeb.Plugs.Authentication do
  import Plug.Conn

  alias DGUWeb.CKAN.Client
  alias DGUWeb.{Repo, User, Publisher}

  def init(default), do: default

  def call(conn, _default) do
    current_user = get_session(conn, :current_user)
    ckan_host = Application.get_env(:dguweb, :ckan )

    if current_user do
      user = Repo.get!(User, current_user)

      conn = conn
      |> assign(:current_user, user)
      |> assign(:ckan, Client.new(ckan_host, user.apikey || ""))

      publishers = Publisher.list_for_user(conn)
      assign(conn, :user_publishers, publishers)
    else
      conn
      |> assign(:ckan, Client.new(ckan_host))
      |> assign(:user_publishers, %{})
    end

  end
end