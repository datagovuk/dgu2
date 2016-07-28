defmodule DGUWeb.PageControllerTest do
  use DGUWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "published by government departments"
  end
end
