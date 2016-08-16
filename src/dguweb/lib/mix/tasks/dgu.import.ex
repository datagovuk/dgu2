defmodule Mix.Tasks.Dgu.Import do
  use Mix.Task

  alias Poison, as: JSON
  alias DGUWeb.{EctoRepo, Repo, Publisher, Dataset}

  def run([]) do
    IO.puts "Please specify the JSON file containing the data"
  end

  def run([path]) do
    Mix.Task.run "app.start", []

    datasets = path
    |> File.read!
    |> JSON.decode!(keys: :atoms)
    |> filter
    |> prep
    |> Enum.filter(&(&1))
    |> Enum.each(fn dataset->
      Repo.insert!(dataset)
    end)
  end

  def prep(datasets) do
    pubmap = %{
      "cabinet-office"=> Repo.get_by!(Publisher, name: "cabinet-office"),
      "department-for-environment-food-and-rural-affairs" => Repo.get_by!(Publisher, name: "department-for-environment-food-rural-affairs"),
      "department-for-transport"  => Repo.get_by!(Publisher, name: "department-for-transport"),
    }

    datasets
    |> Enum.map(fn dataset->
      publisher = Map.get(pubmap, hd(dataset.groups || [""]))
      if publisher do
        Dataset.changeset(%Dataset{}, %{
          name: dataset.name,
          title: dataset.title,
          description: dataset.notes || "No description given",
          publisher_id: publisher.id,
        })
      else
        nil
      end
    end)
  end

  def filter(items) do
    items
    |> Enum.filter(fn dataset->
      length(dataset.groups) > 0 && hd(dataset.groups) in ["cabinet-office", "department-for-transport", "department-for-environment-food-rural-affairs"]
    end)
  end

end