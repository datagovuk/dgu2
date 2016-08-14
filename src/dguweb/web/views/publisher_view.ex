defmodule DGUWeb.PublisherView do
  use DGUWeb.Web, :view

  alias DGUWeb.Session
  alias DGUWeb.User

  # FIXME(rdj): Replace when Authz in place.
  def user_in_publisher(conn, publisher) do
    publishers = conn
    |> Session.current_user()
    |>  publishers_for_user
    |> Enum.filter( fn {pub, role} ->
      pub.name == publisher
    end)

    length(publishers) > 0
  end

  def publishers_for_user(nil), do: []
  def publishers_for_user(user) do
    User.publishers(user)
  end

end
