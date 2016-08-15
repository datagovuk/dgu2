defmodule DGUWeb.UploadTest do
  use DGUWeb.ModelCase

  alias DGUWeb.Upload

  @valid_attrs %{name: "simple", description: "A description",
    content_type: "some content", dataset: "some content",
    errors: [], path: "some content", publisher: "some content",
    url: "some content", warnings: []
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Upload.changeset(%Upload{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Upload.changeset(%Upload{}, @invalid_attrs)
    refute changeset.valid?
  end
end
