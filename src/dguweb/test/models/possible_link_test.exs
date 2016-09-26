defmodule DGUWeb.PossibleLinkTest do
  use DGUWeb.ModelCase

  alias DGUWeb.PossibleLink

  @valid_attrs %{publisher_name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PossibleLink.changeset(%PossibleLink{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PossibleLink.changeset(%PossibleLink{}, @invalid_attrs)
    refute changeset.valid?
  end
end
