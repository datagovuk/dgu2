defmodule DGUWeb.Publisher do
  use DGUWeb.Web, :model

  alias Cachex
  alias CKAN.Client

  schema "publishers" do
    field :name, :string
    field :title, :string
    field :url, :string
    field :description, :string
    has_many :datasets, DGUWeb.Dataset

    field :abbreviation, :string
    field :category, :string
    field :closed, :boolean

    field :foi_name, :string
    field :foi_email, :string
    field :foi_web, :string
    field :foi_phone, :string

    field :contact_name, :string
    field :contact_email, :string
    field :contact_phone, :string

    many_to_many :users, DGUWeb.User, join_through: DGUWeb.PublisherUser

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :title, :url, :description, :abbreviation, :category, :closed])
    |> validate_required([:name, :title, :url])
  end

  def show(conn, id) do
    key = "organization_show:#{id}"
    case Cachex.get!(:request_cache, key) do
      nil ->
        call = Client.organization_show(conn.assigns[:ckan], [id: id, include_datasets: false])
        publisher_or_nil(key, call)
      results ->
        results
    end
  end

  def publisher_or_nil(_key, %{error: _error}) do
   nil
  end

  def publisher_or_nil(key, response) do
    Cachex.set(:request_cache, key, response.result, DGUWeb.cache_opts)
    response.result
  end

  def list(conn) do
    case Cachex.get!(:request_cache, "organization_list") do
      nil ->
        call = Client.organization_list(conn.assigns[:ckan], [all_fields: true, ])
        Cachex.set(:request_cache, "organization_list", call.result, DGUWeb.cache_opts)
        call.result
      results ->
        results
    end
  end

  def list_for_user(conn) do
    user = conn.assigns[:current_user]
    key = "organization_list_user:#{user.username}"

    case Cachex.get!(:request_cache, key) do
      nil ->
        call = Client.organization_list_for_user(conn.assigns[:ckan], [])
        orgs = call.result
        |> Enum.map(fn organisation ->
          {organisation.name, organisation.title}
        end)
        |> Enum.into(%{})
        Cachex.set(:request_cache, key, orgs)
        orgs
      results -> results
    end
  end

end
