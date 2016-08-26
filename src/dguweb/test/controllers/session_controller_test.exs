defmodule DGUWeb.SessionControllerTest do
  use DGUWeb.ConnCase

  alias DGUWeb.User
  @valid_attrs %{username: "bob", email: "bob@localhost.local", password: "Password"}
  @invalid_attrs %{password: "pass"}


  test "valid user can register", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == "/"
    assert Repo.get_by(User, username: "bob")
  end

  test "invalid user can register", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Create an account"
  end

  test "valid user can login", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == "/"

    conn = post conn, session_path(conn, :login), session: %{username: "bob", password: "Password"}
    assert redirected_to(conn) == "/user"

    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Sign out"
  end

  test "invalid user cannot login", %{conn: conn} do
    conn = post conn, session_path(conn, :login), session: %{username: "fake", password: "fake"}
    assert html_response(conn, 200) =~ "Sign in"
  end

  test "logout does nothing if not logged in", %{conn: conn} do
    conn = get conn, session_path(conn, :logout)
    assert redirected_to(conn) == "/"

    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Sign in"
  end

  test "logout works when logged in", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: @valid_attrs
    assert redirected_to(conn) == "/"

    conn = post conn, session_path(conn, :login), session: %{username: "bob", password: "Password"}
    assert redirected_to(conn) == "/user"

    conn = get conn, session_path(conn, :logout)
    assert redirected_to(conn) == "/"

    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Sign in"
  end
end
