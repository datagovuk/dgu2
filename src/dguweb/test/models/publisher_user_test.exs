defmodule DGUWeb.PublisherUserTest do
  use DGUWeb.ModelCase

  alias DGUWeb.PublisherUser

  @valid_attrs %{publisher_id: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PublisherUser.changeset(%PublisherUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PublisherUser.changeset(%PublisherUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
