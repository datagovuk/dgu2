defmodule DGUWeb.User do
  use DGUWeb.Web, :model

  alias DGUWeb.Repo
  alias DGUWeb.PublisherUser

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :crypted_password, :string

    many_to_many :publisher, DGUWeb.Publisher, join_through: PublisherUser

    timestamps()
  end

  @doc """
  Retrieves the publishers that the given user is a member of. Because we want the role 
  field in the join table however, we need to also map them separately to the memberships 
  so we query the join table as well.  One day I hope this is fixed to allow the fields in 
  the join table to be retrieved as part of the same call.
  """
  def publishers(user) do 
      publishers = Repo.all assoc(user, :publisher)
      memberships = Repo.all(from(p in PublisherUser, where: p.user_id == ^user.id))

      member_map = memberships 
      |> Enum.map(fn x ->   
          {x.publisher_id, x.role}
      end)
      |> Enum.into(%{})

      publishers
      |> Enum.map( fn p -> 
        {p, Map.get(member_map, p.id)}
      end)
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

