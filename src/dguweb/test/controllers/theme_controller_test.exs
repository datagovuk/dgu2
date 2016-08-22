defmodule DGUWeb.ThemeControllerTest do
  use DGUWeb.ConnCase

  alias DGUWeb.Theme
  @valid_attrs %{name: "test", title: "test", description: "Description"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, theme_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing themes"
  end

  test "shows chosen resource", %{conn: conn} do
    theme = Repo.insert! %Theme{name: "scr_test", title: "Test Theme"}
    conn = get conn, theme_path(conn, :show, theme.name)
    assert html_response(conn, 200) =~ "Test Theme"
  end


end
