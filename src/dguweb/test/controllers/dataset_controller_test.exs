defmodule DGUWeb.DatasetControllerTest do
  use DGUWeb.ConnCase

  alias DGUWeb.Dataset
  alias DGUWeb.Publisher 

  @publisher %Publisher{name: "some content", title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, dataset_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing datasets"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, dataset_path(conn, :new)
    assert html_response(conn, 200) =~ "New dataset"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    pub = Repo.insert! @publisher 
    conn = post conn, dataset_path(conn, :create), dataset:   %{name: "some content", title: "some content", publisher_id: pub.id}
    assert redirected_to(conn) == dataset_path(conn, :index)
    assert Repo.get_by(Dataset, name: "some content")
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, dataset_path(conn, :create), dataset: @invalid_attrs
    assert html_response(conn, 200) =~ "New dataset"
  end

  test "shows chosen resource", %{conn: conn} do
    dataset = Repo.insert! %Dataset{}
    conn = get conn, dataset_path(conn, :show, dataset)
    assert html_response(conn, 200) =~ "Show dataset"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, dataset_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    dataset = Repo.insert! %Dataset{}
    conn = get conn, dataset_path(conn, :edit, dataset)
    assert html_response(conn, 200) =~ "Edit dataset"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    pub = Repo.insert! @publisher 
    dataset = Repo.insert! %Dataset{name: "some content", title: "some content", publisher_id: pub.id}
    conn = put conn, dataset_path(conn, :update, dataset), dataset: %{name: "some content", title: "some content", publisher_id: pub.id}
    assert redirected_to(conn) == dataset_path(conn, :show, dataset)
    assert Repo.get_by(Dataset, name: "some content")
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    dataset = Repo.insert! %Dataset{}
    conn = put conn, dataset_path(conn, :update, dataset), dataset: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit dataset"
  end

  test "deletes chosen resource", %{conn: conn} do
    dataset = Repo.insert! %Dataset{}
    conn = delete conn, dataset_path(conn, :delete, dataset)
    assert redirected_to(conn) == dataset_path(conn, :index)
    refute Repo.get(Dataset, dataset.id)
  end
end
