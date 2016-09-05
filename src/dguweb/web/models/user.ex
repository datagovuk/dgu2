defmodule DGUWeb.User do
  use DGUWeb.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :crypted_password, :string
    field :apikey, :string

    timestamps()
  end

  @doc """
  Retrieves the publishers that the given user is a member of. Because we want the role
  field in the join table however, we need to also map them separately to the memberships
  so we query the join table as well.  One day I hope this is fixed to allow the fields in
  the join table to be retrieved as part of the same call.
  """
  def publishers(conn, _user) do
      conn.assigns(:user_publishers)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email, :password, :crypted_password])
    |> validate_required([:username, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> unique_constraint(:username)
  end
end

