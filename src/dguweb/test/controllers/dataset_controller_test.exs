defmodule DGUWeb.DatasetControllerTest do
  use DGUWeb.ConnCase

  alias DGUWeb.Dataset
  alias DGUWeb.Publisher 

  @publisher %Publisher{name: "some content", title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, dataset_path(conn, :index)
    assert html_response(conn, 200) =~ "Datasets"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, dataset_path(conn, :new)
    assert html_response(conn, 200) =~ "New dataset"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    pub = Repo.insert! @publisher 
    conn = post conn, dataset_path(conn, :create), dataset:   %{name: "test", title: "some content", publisher_id: pub.id}
    assert redirected_to(conn) == dataset_path(conn, :index)
    assert Repo.get_by(Dataset, name: "test")
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, dataset_path(conn, :create), dataset: @invalid_attrs
    assert html_response(conn, 200) =~ "New dataset"
  end

  test "shows chosen resource", %{conn: conn} do
    dataset = Repo.insert! %Dataset{name: "test", title: "Title"}
    conn = get conn, dataset_path(conn, :show, dataset.name)
    assert html_response(conn, 200) =~ "Title"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, dataset_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    dataset = Repo.insert! %Dataset{name: "test"}
    conn = get conn, dataset_path(conn, :edit, dataset.name)
    assert html_response(conn, 200) =~ "Edit dataset"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    pub = Repo.insert! @publisher 
    dataset = Repo.insert! %Dataset{name: "test", title: "some content", publisher_id: pub.id}
    conn = put conn, dataset_path(conn, :update, dataset.name), dataset: %{name: "test", title: "some content", publisher_id: pub.id}
    assert redirected_to(conn) == dataset_path(conn, :show, dataset.name)
    assert Repo.get_by(Dataset, name: "test")
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    dataset = Repo.insert! %Dataset{name: "test"}
    conn = put conn, dataset_path(conn, :update, dataset.name), dataset: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit dataset"
  end

  test "deletes chosen resource", %{conn: conn} do
    dataset = Repo.insert! %Dataset{name: "test"}
    conn = delete conn, dataset_path(conn, :delete, dataset.name)
    assert redirected_to(conn) == dataset_path(conn, :index)
    refute Repo.get(Dataset, dataset.id)
  end
end
