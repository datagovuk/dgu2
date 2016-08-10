defmodule DGUWeb.User do
  use DGUWeb.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true

    field :crypted_password, :string
    timestamps()
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

