defmodule DGUWeb.PossibleLinkControllerTest do
  use DGUWeb.ConnCase

  alias DGUWeb.PossibleLink
  @valid_attrs %{}
  @invalid_attrs %{}

  test "shows chosen resource", %{conn: conn} do
    conn = get conn, possible_link_path(conn, :show, "cabinet-office")
    assert html_response(conn, 200) =~ "Data links"
  end


  test "deletes chosen resource", %{conn: conn} do
    possible_link = Repo.insert! %PossibleLink{url: "", publisher_name: "cabinet-office", processed: false}

    conn = delete conn, possible_link_path(conn, :delete, possible_link)
    assert redirected_to(conn) == possible_link_path(conn, :show, "cabinet-office")
    refute Repo.get(PossibleLink, possible_link.id)
  end
end
