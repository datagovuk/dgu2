defmodule DGUWeb.ThemeControllerTest do
  use DGUWeb.ConnCase

  alias DGUWeb.Theme
  @valid_attrs %{name: "test", title: "test", description: "Description"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, theme_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing themes"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, theme_path(conn, :new)
    assert html_response(conn, 200) =~ "New theme"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, theme_path(conn, :create), theme: @valid_attrs
    assert redirected_to(conn) == theme_path(conn, :index)
    assert Repo.get_by(Theme, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, theme_path(conn, :create), theme: @invalid_attrs
    assert html_response(conn, 200) =~ "New theme"
  end

  test "shows chosen resource", %{conn: conn} do
    theme = Repo.insert! %Theme{name: "scr_test", title: "Test Theme"}
    conn = get conn, theme_path(conn, :show, theme.name)
    assert html_response(conn, 200) =~ "Test Theme"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, theme_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    theme = Repo.insert! %Theme{name: "trf_test"}
    conn = get conn, theme_path(conn, :edit, theme.name)
    assert html_response(conn, 200) =~ "Edit theme"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    theme = Repo.insert! (%Theme{} |> Map.merge(@valid_attrs))
    conn = put conn, theme_path(conn, :update, theme.name), theme: @valid_attrs
    assert redirected_to(conn) == theme_path(conn, :show, theme.name)
    assert Repo.get_by(Theme, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    theme = Repo.insert! %Theme{name: "dnu_test"}
    conn = put conn, theme_path(conn, :update, theme.name), theme: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit theme"
  end

  test "deletes chosen resource", %{conn: conn} do
    theme = Repo.insert! %Theme{name: "dcr_test"}
    conn = delete conn, theme_path(conn, :delete, theme.name)
    assert redirected_to(conn) == theme_path(conn, :index)
    refute Repo.get(Theme, theme.id)
  end
end
