defmodule DGUWeb.DatasetTest do
  use DGUWeb.ModelCase

  alias DGUWeb.Dataset

  @valid_attrs %{name: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Dataset.changeset(%Dataset{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Dataset.changeset(%Dataset{}, @invalid_attrs)
    refute changeset.valid?
  end
end
