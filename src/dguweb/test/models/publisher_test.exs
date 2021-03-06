defmodule DGUWeb.PublisherTest do
  use DGUWeb.ModelCase

  alias DGUWeb.Publisher

  @valid_attrs %{name: "some content", title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Publisher.changeset(%Publisher{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Publisher.changeset(%Publisher{}, @invalid_attrs)
    refute changeset.valid?
  end
end
