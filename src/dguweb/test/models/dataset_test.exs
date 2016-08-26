defmodule DGUWeb.DatasetTest do
  use DGUWeb.ModelCase

  alias DGUWeb.Dataset

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Dataset.changeset(%Dataset{}, %{
      name: "some content", title: "some content", description: "Description", publisher_id: "naptan",
      owner_org: "cabinet-office"
    })
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Dataset.changeset(%Dataset{}, @invalid_attrs)
    refute changeset.valid?
  end
end
