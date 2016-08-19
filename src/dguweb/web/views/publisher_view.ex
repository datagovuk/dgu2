defmodule DGUWeb.PublisherView do
  use DGUWeb.Web, :view

  alias DGUWeb.User

  def user_in_publisher(conn, publisher) do
    publishers = conn.assigns[:user_publishers] || []

    member_of = Enum.filter(publishers, fn {pub, _publishermap} ->
      pub == publisher
    end)

    length(member_of) > 0
  end

end
