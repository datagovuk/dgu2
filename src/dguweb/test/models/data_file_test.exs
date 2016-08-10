defmodule DGUWeb.DataFileTest do
  use DGUWeb.ModelCase

  alias DGUWeb.DataFile

  @valid_attrs %{description: "some content", format: "some content", name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DataFile.changeset(%DataFile{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DataFile.changeset(%DataFile{}, @invalid_attrs)
    refute changeset.valid?
  end
end
