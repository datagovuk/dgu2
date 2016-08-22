defmodule DGUWeb.ThemeView do
  use DGUWeb.Web, :view

  # FIXME(rdj): Remove when we have authz.
  def user_in_publisher(conn, publisher) do
    publishers = conn.assigns[:user_publishers] || []
    |> Enum.filter( fn {pub, _role} ->
      pub.name == publisher
    end)

    map_size(publishers) > 0
  end

end
