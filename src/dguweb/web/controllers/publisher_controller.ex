defmodule DGUWeb.PublisherController do
  use DGUWeb.Web, :controller

  alias DGUWeb.{Repo, Publisher, Dataset}
  alias DGUWeb.Util.Pagination

  def index(conn, _params) do
    render(conn, "index.html", publishers: Publisher.list(conn))
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
    publisher = Publisher.show(conn, id)
    page_number = get_page_number(params)
    show_publisher(conn, publisher, page_number)
  end

  def show_publisher(conn, nil, _page_number) do
   conn
   |> put_status(:not_found)
   |> render(DGUWeb.ErrorView, "404.html")
  end

  def show_publisher(conn, publisher, page_number) do
    page_number = if page_number < 1, do: 1, else: page_number
    offset = case page_number do
      1 ->
         0
      other ->
        ((other * 10) - 10)
    end

    response = Dataset.search(conn, "", [fq: "organization:#{publisher.name}", rows: 10, start: offset])
    pagination = Pagination.create(response.count)

    render(conn, "show.html", publisher: publisher, datasets: response.results,
      pagination: pagination, page_number: page_number, offset: offset)
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
