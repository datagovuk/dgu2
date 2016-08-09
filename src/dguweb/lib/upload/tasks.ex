defmodule DGUWeb.Upload.Tasks do 
  @moduledoc """
  Tasks for processing urls and uploaded files
  """

  alias DGUWeb.Upload.Info 

  # The list of tasks that should be run against urls that are provided
  def url_tasks do 
    [
      {__MODULE__, :info_from_headers},
      {__MODULE__, :print}
    ]
  end 

  # The list of tasks that should be run against files that are uploaded.  
  def file_tasks do 
    [
      {__MODULE__, :print}
    ]
  end 

  @doc """
  Runs all of the tasks for the upload type making sure that each one 
  returns an Info (either updated or not). If at any stage errors are 
  added to the Info then no further processing will happen.
  """
  def run_tasks(info, tasks) do 
    Enum.reduce(tasks, info, fn ({m, f}, acc)-> 
      apply_func(m, f, acc, length(acc.errors))
    end)
  end

  def apply_func(m, f, acc, 0), do: apply(m, f, [acc])
  def apply_func(_, _, acc, _error_count), do: acc

  @doc """
  Just for debugging, prints out the current Info struct.
  """
  def print(info) do 
    IO.inspect info
  end 

  @doc """
  Retrieves from information, if possible, from a HEAD request to the URL of the 
  resource.  
  """
  def info_from_headers(info) do 
    case HTTPoison.head(info.filename) do
      {:ok, %HTTPoison.Response{status_code: 200, headers: headers}} ->
        headermap = Enum.into(headers, %{})
        %Info{info | 
          size: Map.get(headermap, "Content-Length"),
          content_type: Map.get(headermap, "Content-Type")
        }
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        %Info{info | 
          errors: ["URL was not found" | info.errors],
        }
      {:error, %HTTPoison.Error{reason: reason}} ->
        %Info{info | 
          warnings: [reason | info.warnings],
        }
      x ->
        %Info{info | 
          warnings: ["Request failed" | info.warnings],
        }
    end
  end 


end