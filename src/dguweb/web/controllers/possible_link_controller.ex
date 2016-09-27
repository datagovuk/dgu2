defmodule DGUWeb.PossibleLinkController do
  use DGUWeb.Web, :controller

  alias DGUWeb.{PossibleLink, Publisher}

  def show(conn, %{"id" => id}) do
    publisher = Publisher.show(conn, id)
    render(conn, "show.html", possible_links: PossibleLink.get_for_publisher(id),
      publisher: publisher)
  end


  def delete(conn, %{"id" => id}) do
    possible_link = Repo.get!(PossibleLink, id)

    pubname = possible_link.publisher_name

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(possible_link)

    conn
    |> put_flash(:info, "Possible link deleted successfully.")
    |> redirect(to: possible_link_path(conn, :show, pubname ))
  end
end
