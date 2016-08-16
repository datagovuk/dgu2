defmodule Mix.Tasks.Dgu.AssignUser do
  use Mix.Task

  alias Poison, as: JSON
  alias DGUWeb.{Repo, Publisher, User, PublisherUser}

  def run([]) do
    IO.puts "Please specify the username and the publisher name"
  end

  def run([username, publishername]) do
    Mix.Task.run "app.start", []

    user = Repo.get_by(User, username: username)
    publisher = Repo.get_by(Publisher, name: publishername)
    process(user, publisher)
  end

  def process(nil, nil), do: IO.puts "User and Publisher not found"
  def process(_user, nil), do: IO.puts "Publisher not found"
  def process(nil, _publisher), do: IO.puts "User not found"
  def process(user, publisher) do

    case Repo.get_by(PublisherUser, user_id: user.id, publisher_id: publisher.id) do
      nil ->
        PublisherUser.changeset(%PublisherUser{}, %{
          user_id: user.id, publisher_id: publisher.id, role: "admin"}
        ) |>  Repo.insert_or_update!
      entry ->  nil
    end

  end

end
