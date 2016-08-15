defmodule DGUWeb.UploadControllerTest do
  use DGUWeb.ConnCase

  alias DGUWeb.Upload
  alias DGUWeb.{Dataset, Publisher}

  @valid_attrs %{name: "simple", description: "A description", content_type: "some content",
    dataset: nil, errors: [], path: "some content", publisher: "testpub",
    url: "some content", warnings: []
  }
  @invalid_attrs %{}

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, upload_path(conn, :new)
    assert html_response(conn, 200) =~ "URL"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    pub = Repo.insert! %Publisher{name: "testpub", title: "some content",description: "Description", url: "some content"}
    post conn, upload_path(conn, :create), upload: @valid_attrs
    assert Repo.get_by(Upload, description: "A description" )
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, upload_path(conn, :create), upload: @invalid_attrs
    assert html_response(conn, 200) =~ "URL"
  end

  test "shows chosen resource", %{conn: conn} do
    pub = Repo.insert! %Publisher{name: "testpub", title: "some content",description: "Description", url: "some content"}

    cs = Upload.changeset(%Upload{}, @valid_attrs)
    upload = Repo.insert!(cs)

    conn = get conn, upload_path(conn, :show, upload.id)
    assert html_response(conn, 200) =~ "Where would you like to add these files"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, upload_path(conn, :show, -1)
    end
  end

end
