defmodule DGUWeb.PublisherControllerTest do
  use DGUWeb.ConnCase

  @valid_attrs %{name: "some content", title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, publisher_path(conn, :index)
    assert html_response(conn, 200) =~ "Organisations"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, publisher_path(conn, :new)
    assert html_response(conn, 200) =~ "Add an organisation"
  end

  test "creates resource and redirects when data is valid", %{conn: _conn} do
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, publisher_path(conn, :create), publisher: @invalid_attrs
    assert html_response(conn, 200) =~ "Add an organisation"
  end

  test "shows chosen resource", %{conn: conn} do
    conn = get conn, publisher_path(conn, :show, "cabinet-office")
    assert html_response(conn, 200) =~ "Cabinet Office"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->

      get conn, publisher_path(conn, :show, "wombles")
      html_response(conn, 200)
    end
  end

  test "renders form for editing chosen resource", %{conn: _conn} do
  end

  test "updates chosen resource and redirects when data is valid", %{conn: _conn} do
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: _conn} do
  end

  test "deletes chosen resource", %{conn: _conn} do
  end
end
