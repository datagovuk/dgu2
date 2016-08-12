defmodule DGUWeb.DatasetTest do
  use DGUWeb.ModelCase

  alias DGUWeb.Repo
  alias DGUWeb.Publisher
  alias DGUWeb.Dataset

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    pub = Repo.insert! %Publisher{name: "some content", title: "some content",description: "Description", url: "some content"}
    changeset = Dataset.changeset(%Dataset{}, %{
      name: "some content", title: "some content", description: "Description", publisher_id: pub.id
    })
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Dataset.changeset(%Dataset{}, @invalid_attrs)
    refute changeset.valid?
  end
end
