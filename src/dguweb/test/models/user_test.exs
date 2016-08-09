defmodule DGUWeb.UserTest do
  use DGUWeb.ModelCase

  alias DGUWeb.User

  @valid_attrs %{password: "some content", email: "someone@localhost.local", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
