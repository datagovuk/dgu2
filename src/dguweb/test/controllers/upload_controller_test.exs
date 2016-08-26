defmodule DGUWeb.UploadControllerTest do
  use DGUWeb.ConnCase


  test "renders form for new resources", %{conn: conn} do
    conn = get conn, upload_path(conn, :new)
    assert html_response(conn, 200) =~ "URL"
  end

  test "creates resource and redirects when data is valid", %{conn: _conn} do
  end

  test "does not create resource and renders errors when data is invalid", %{conn: _conn} do
  end

  test "shows chosen resource", %{conn: _conn} do
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, upload_path(conn, :show, -1)
    end
  end

end
