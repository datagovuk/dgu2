defmodule DGUWeb.SearchControllerTest do
  use DGUWeb.ConnCase

  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on query when empty", %{conn: conn} do
    conn = get conn, search_path(conn, :search, q: "")
    assert json_response(conn, 200) == []
  end


end
