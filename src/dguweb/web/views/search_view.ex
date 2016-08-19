defmodule DGUWeb.SearchView do
  use DGUWeb.Web, :view

  alias DGUWeb.User

  def render("search.json", %{results: datasets}) do
    datasets
  end

  # FIXME(rdj): Remove when we have authz.
  def user_in_publisher(conn, publisher) do
    publishers = conn.assigns[:user_publishers] || []
    |> Enum.filter( fn {pub, _role} ->
      pub.name == publisher
    end)

    map_size(publishers) > 0
  end

  def publishers_for_user(nil), do: []
  def publishers_for_user(user) do
    User.publishers(user)
  end

end
