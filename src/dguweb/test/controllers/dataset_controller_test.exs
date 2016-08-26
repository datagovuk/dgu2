defmodule DGUWeb.DatasetControllerTest do
  use DGUWeb.ConnCase


  test "lists all entries on index", %{conn: conn} do
    conn = get conn, dataset_path(conn, :index)
    assert html_response(conn, 200) =~ "Datasets"
  end

  test "renders form for new resources", %{conn: _conn} do

  end

  test "shows chosen resource", %{conn: conn} do
    conn = get conn, dataset_path(conn, :show, "naptan")
    assert html_response(conn, 200) =~ "NaPTAN is Britain's national system"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    c = get conn, dataset_path(conn, :show, "wombles")
    assert html_response(c, 404) =~ "Page not found"
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
