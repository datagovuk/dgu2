defmodule DGUWeb.DatasetControllerTest do
  use DGUWeb.ConnCase

  alias DGUWeb.Dataset
  alias DGUWeb.Publisher
  alias DGUWeb.Upload

  @publisher %Publisher{name: "some content", title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, dataset_path(conn, :index)
    assert html_response(conn, 200) =~ "Datasets"
  end

  test "renders form for new resources", %{conn: conn} do
    publisher = Repo.insert!(@publisher)
    upload = Repo.insert!(%Upload{publisher: publisher.name})

    conn = get conn, dataset_path(conn, :new, upload: upload.id)
    assert html_response(conn, 200) =~ "Add data"
  end

  test "shows chosen resource", %{conn: conn} do
    conn = get conn, dataset_path(conn, :show, "naptan")
    assert html_response(conn, 200) =~ "NaPTAN is Britain's national system"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    c = get conn, dataset_path(conn, :show, "wombles")
    assert html_response(c, 404) =~ "Page not found"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    publisher = Repo.insert!(@publisher)
    upload = Repo.insert!(%Upload{publisher: publisher.name})
    dataset = Repo.insert! %Dataset{name: "test", description: "Desc", title: "Title", publisher_id: publisher.id}

    conn = get conn, dataset_path(conn, :edit, dataset.name, upload: upload.id)
    assert html_response(conn, 200) =~ "Edit dataset"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    pub = Repo.insert! @publisher
    dataset = Repo.insert! %Dataset{name: "test", title: "some content", publisher_id: pub.id}
    conn = put conn, dataset_path(conn, :update, dataset.name), dataset: %{
      name: "test", title: "some content", description: "Description", publisher_id: pub.id
    }
    assert redirected_to(conn) == dataset_path(conn, :show, dataset.name)
    assert Repo.get_by(Dataset, name: "test")
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    publisher = Repo.insert!(@publisher)
    dataset = Repo.insert! %Dataset{name: "test", publisher_id: publisher.id}

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
