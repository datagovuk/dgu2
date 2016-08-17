defmodule DGUWeb.PublisherController do
  use DGUWeb.Web, :controller

  alias DGUWeb.{Repo, Publisher, Dataset}
  alias DGUWeb.Util.Pagination

  def index(conn, _params) do
    publishers = Repo.all(Publisher)

    render(conn, "index.html", publishers: publishers)
  end

  def new(conn, _params) do
    changeset = Publisher.changeset(%Publisher{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"publisher" => publisher_params}) do
    changeset = Publisher.changeset(%Publisher{}, publisher_params)

    case Repo.insert(changeset) do
      {:ok, _publisher} ->
        conn
        |> put_flash(:info, "Publisher created successfully.")
        |> redirect(to: publisher_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}=params) do
    publisher = Repo.get_by!(Publisher, name: id)

    count = Repo.all(from d in Dataset,
      where: d.publisher_id == ^publisher.id,
      select: count(d.id)) |> hd

    page_number = get_page_number(params)
    pagination = Pagination.create(count)
    offset = Pagination.offset_for_page(pagination, page_number)

    datasets = Repo.all(from d in Dataset,
      where: d.publisher_id == ^publisher.id,
      offset: ^offset,
      limit: 10,
      order_by: [asc: d.updated_at])

    render(conn, "show.html", publisher: publisher, datasets: datasets, pagination: pagination,
      page_number: page_number, offset: offset)
  end


  defp get_page_number(params) do
    params |> Map.get("page", "1") |> String.to_integer
  end

  def edit(conn, %{"id" => id}) do
    publisher = Repo.get_by!(Publisher, name: id)
    changeset = Publisher.changeset(publisher)
    render(conn, "edit.html", publisher: publisher, changeset: changeset)
  end

  def update(conn, %{"id" => id, "publisher" => publisher_params}) do
    publisher = Repo.get_by!(Publisher, name: id)
    changeset = Publisher.changeset(publisher, publisher_params)

    case Repo.update(changeset) do
      {:ok, publisher} ->
        conn
        |> put_flash(:info, "Publisher updated successfully.")
        |> redirect(to: publisher_path(conn, :show, publisher.name))
      {:error, changeset} ->
        render(conn, "edit.html", publisher: publisher, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    publisher = Repo.get_by!(Publisher, name: id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(publisher)

    conn
    |> put_flash(:info, "Publisher deleted successfully.")
    |> redirect(to: publisher_path(conn, :index))
  end
end
