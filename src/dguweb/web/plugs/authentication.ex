defmodule DGUWeb.Plugs.Authentication do
  import Plug.Conn

  alias CKAN.Client
  alias DGUWeb.{Repo, User, Publisher}

  def init(default), do: default

  def call(conn, _default) do
    current_user = get_session(conn, :current_user)
    if current_user do
      user = Repo.get!(User, current_user)

      conn = conn
      |> assign(:current_user, user)
      |> assign(:ckan, Client.new("https://test.data.gov.uk", user.apikey || ""))

      publishers = Publisher.list_for_user(conn)
      assign(conn, :user_publishers, publishers)
    else
      conn
      |> assign(:ckan, Client.new("https://test.data.gov.uk"))
    end

  end
end