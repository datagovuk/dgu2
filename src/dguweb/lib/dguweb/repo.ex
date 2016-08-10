defmodule DGUWeb.EctoRepo do
  use Ecto.Repo, otp_app: :dguweb
  use Scrivener, page_size: 10
end


defmodule DGUWeb.Repo do
  alias DGUWeb.EctoRepo
  alias DGUWeb.{Dataset, Publisher}

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
    EctoRepo.delete_all(queryable, opts)
    model_event(queryable, :clear)
  end

  defp handle_repo_return(return, type) do
    case return do
      {:ok, model} = good ->
        model_event(model, type)
        good
      otherwise -> otherwise
    end
  end

  defp model_event(%Dataset{} = model, :insert) do
    model 
  end
  defp model_event(%Publisher{} = model, :insert) do
    model 
  end
  defp model_event(%Dataset{} = model, :update) do
    model 
  end
  defp model_event(%Publisher{} = model, :update) do
    model 
  end
  defp model_event(%Dataset{} = model, :delete) do
    model 
  end
  defp model_event(%Publisher{} = model, :delete) do
    model 
  end  
  defp model_event(%Dataset{} = model, :clear) do
    model 
  end
  defp model_event(%Publisher{} = model, :clear) do
    model 
  end  

  defp model_event(_model, :update), do: :nothing
  defp model_event(_model, :insert), do: :nothing
end