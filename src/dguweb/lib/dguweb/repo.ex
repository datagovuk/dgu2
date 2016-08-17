defmodule DGUWeb.EctoRepo do
  use Ecto.Repo, otp_app: :dguweb
  use Scrivener, page_size: 10
end


defmodule DGUWeb.Repo do
  alias DGUWeb.EctoRepo
  alias DGUWeb.Dataset

  alias Tirexs.HTTP, as: Search

  ### Delegated to Repo
  defdelegate __adapter__, to: EctoRepo
  defdelegate __pool__, to: EctoRepo
  defdelegate __sql__, to: EctoRepo
  defdelegate stop(x), to: EctoRepo
  defdelegate start_link(x), to: EctoRepo
  defdelegate config, to: EctoRepo
  defdelegate transaction(opts \\ [], fun), to: EctoRepo
  defdelegate rollback(value), to: EctoRepo
  defdelegate all(queryable, opts \\ []), to: EctoRepo
  defdelegate get(queryable, id, opts \\ []), to: EctoRepo
  defdelegate get!(queryable, id, opts \\ []), to: EctoRepo
  defdelegate get_by(queryable, clauses, opts \\ []), to: EctoRepo
  defdelegate get_by!(queryable, clauses, opts \\ []), to: EctoRepo
  defdelegate one(queryable, opts \\ []), to: EctoRepo
  defdelegate one!(queryable, opts \\ []), to: EctoRepo
  defdelegate insert_all(schema, entries, opts \\ []), to: EctoRepo
  defdelegate update_all(queryable, updates, opts \\ []), to: EctoRepo
  defdelegate insert_or_update(changeset, opts \\ []), to: EctoRepo
  defdelegate insert_or_update!(changeset, opts \\ []), to: EctoRepo
  defdelegate preload(struct_or_structs, preloads), to: EctoRepo
  defdelegate paginate(a, b), to: EctoRepo

  ### Custom functions #######################################################
  def insert(queryable, opts \\ []) do
    handle_repo_return EctoRepo.insert(queryable, opts), :insert
  end

  def insert!(queryable, opts \\ []) do
    model = EctoRepo.insert!(queryable, opts)
    model_event(model, :insert)
    model
  end

  def update(queryable, opts \\ []) do
    handle_repo_return EctoRepo.update(queryable, opts), :update
  end

  def update!(queryable, opts \\ []) do
    model = EctoRepo.update!(queryable, opts)
    model_event(model, :update)
    model
  end

  def delete(queryable, opts \\ []) do
    handle_repo_return EctoRepo.delete(queryable, opts), :delete
  end

  def delete!(queryable, opts \\ []) do
    model = EctoRepo.delete!(queryable, opts)
    model_event(model, :delete)
    model
  end

  def delete_all(queryable, opts \\ []) do
    handle_repo_return EctoRepo.delete_all(queryable, opts), :clear
  end

  defp handle_repo_return(return, type) do
    case return do
      {:ok, model} = good ->
        model_event(model, type)
        good
      otherwise -> otherwise
    end
  end

  defp index_name, do: Application.get_env(:dguweb, :index)

  def search(q, offset \\ 0, size \\ 10) do
    case Search.get("/#{index_name}/datasets/_search?size=#{size}&from=#{offset}&q=#{q}") do
      {:ok, _status, result } ->
        result
      _ -> nil
    end
  end

  def create_index do
    host = Application.get_env(:tirexs, :uri)
    body = ~s({
    "settings": {
        "index": {
            "number_of_replicas" : 0,
            "number_of_shards": 1,
            "analysis" :{
                "analyzer": {
                    "default": {
                        "type" : "snowball",
                        "language" : "English"
                    }
                }
            }
    }}})
    {:ok, response} = HTTPoison.put("#{host}/#{index_name}", body)
    IO.puts response.body
  end

  def clear_index do
    Search.delete("#{index_name}")
  end

  defp model_event(%Dataset{} = model, :insert) do
    Search.put("#{index_name}/datasets/#{model.id}", Dataset.fields_for_search(model))
    model
  end
  defp model_event(%Dataset{} = model, :update) do
    Search.put("#{index_name}/datasets/#{model.id}", Dataset.fields_for_search(model))
    model
  end
  defp model_event(%Dataset{} = model, :delete) do
    Search.delete("#{index_name}/datasets/#{model.id}")
    model
  end
  defp model_event(%Dataset{} = model, :clear) do
    Search.delete("#{index_name}/datasets")
    model
  end

  defp model_event(_model, :update), do: :nothing
  defp model_event(_model, :insert), do: :nothing
  defp model_event(_model, :delete), do: :nothing
  defp model_event(_model, :clear), do: :nothing
end