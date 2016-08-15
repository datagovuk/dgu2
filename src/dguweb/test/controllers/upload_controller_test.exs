defmodule DGUWeb.UploadControllerTest do
  use DGUWeb.ConnCase

  alias DGUWeb.Upload
  alias DGUWeb.{Dataset, Publisher}

  @valid_attrs %{content_type: "some content", dataset: "test-dataset", errors: [], path: "some content", publisher: "some content", url: "some content", warnings: []}
  @invalid_attrs %{}

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, upload_path(conn, :new)
    assert html_response(conn, 200) =~ "URL"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    pub = Repo.insert! %Publisher{name: "some content", title: "some content",description: "Description", url: "some content"}
    Repo.insert! %Dataset{
      name: "test-dataset",
      title: "Testing",
      description: "A test Dataset",
      publisher_id: pub.id
    }

    post conn, upload_path(conn, :create), upload: @valid_attrs
    assert Repo.get_by(Upload, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, upload_path(conn, :create), upload: @invalid_attrs
    assert html_response(conn, 200) =~ "URL"
  end

  test "shows chosen resource", %{conn: conn} do
    upload = Repo.insert! %Upload{}
    conn = get conn, upload_path(conn, :show, upload)
    assert html_response(conn, 200) =~ "Where would you like to add these files"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, upload_path(conn, :show, -1)
    end
  end

end
