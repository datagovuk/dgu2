defmodule DGUWeb.PublisherControllerTest do
  use DGUWeb.ConnCase

  alias DGUWeb.Publisher
  @valid_attrs %{name: "some content", title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, publisher_path(conn, :index)
    assert html_response(conn, 200) =~ "Publishers"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, publisher_path(conn, :new)
    assert html_response(conn, 200) =~ "Add a publisher"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, publisher_path(conn, :create), publisher: @valid_attrs
    assert redirected_to(conn) == publisher_path(conn, :index)
    assert Repo.get_by(Publisher, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, publisher_path(conn, :create), publisher: @invalid_attrs
    assert html_response(conn, 200) =~ "Add a publisher"
  end

  test "shows chosen resource", %{conn: conn} do
    publisher = Repo.insert! %Publisher{name: "test", title: "Test"}
    conn = get conn, publisher_path(conn, :show, publisher.name)
    assert html_response(conn, 200) =~ publisher.title
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, publisher_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    publisher = Repo.insert! %Publisher{name: "test", title: "Test"}
    conn = get conn, publisher_path(conn, :edit, publisher.name)
    assert html_response(conn, 200) =~ "Edit " <> publisher.title
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    publisher = Repo.insert! (Map.merge(%Publisher{}, @valid_attrs))
    conn = put conn, publisher_path(conn, :update, publisher.name), publisher: @valid_attrs
    assert redirected_to(conn) == publisher_path(conn, :show, publisher.name)
    assert Repo.get_by(Publisher, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    publisher = Repo.insert! %Publisher{name: "test", title: "Test"}
    conn = put conn, publisher_path(conn, :update, publisher.name), publisher: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit " <> publisher.title
  end

  test "deletes chosen resource", %{conn: conn} do
    publisher = Repo.insert! %Publisher{name: "test"}
    conn = delete conn, publisher_path(conn, :delete, publisher.name)
    assert redirected_to(conn) == publisher_path(conn, :index)
    refute Repo.get_by(Publisher, name: publisher.name)
  end
end
