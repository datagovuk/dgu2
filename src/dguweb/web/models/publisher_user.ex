defmodule DGUWeb.PublisherUser do
  use DGUWeb.Web, :model

  schema "publisher_user" do
    field :user_id, :integer
    field :publisher_id, :integer
    field :role, :string, default: "member"
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :publisher_id, :role])
    |> validate_required([:user_id, :publisher_id, :role])
  end
end
