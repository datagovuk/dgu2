defmodule DGUWeb.DatasetView do
  use DGUWeb.Web, :view

  alias DGUWeb.User

  # FIXME(rdj): Remove when we have authz.
  def user_in_publisher(conn, publisher) do
    publishers = conn.assigns[:user_publishers] || []
    |> Enum.filter( fn {pub, _role} ->
      pub.name == publisher
    end)

    length(publishers) > 0
  end

  def publishers_for_user(nil), do: []
  def publishers_for_user(user) do
    User.publishers(user)
  end
end
