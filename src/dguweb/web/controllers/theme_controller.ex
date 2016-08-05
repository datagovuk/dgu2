defmodule DGUWeb.ThemeController do
  use DGUWeb.Web, :controller

  alias DGUWeb.Theme

  def index(conn, _params) do
    themes = Repo.all(Theme)
    render(conn, "index.html", themes: themes)
  end

  def new(conn, _params) do
    changeset = Theme.changeset(%Theme{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"theme" => theme_params}) do
    changeset = Theme.changeset(%Theme{}, theme_params)

    case Repo.insert(changeset) do
      {:ok, _theme} ->
        conn
        |> put_flash(:info, "Theme created successfully.")
        |> redirect(to: theme_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    theme = Repo.get_by!(Theme, name: id)
    render(conn, "show.html", theme: theme)
  end

  def edit(conn, %{"id" => id}) do
    theme = Repo.get_by!(Theme, name: id) 
    changeset = Theme.changeset(theme)
    render(conn, "edit.html", theme: theme, changeset: changeset)
  end

  def update(conn, %{"id" => id, "theme" => theme_params}) do
    theme = Repo.get_by!(Theme, name: id)
    changeset = Theme.changeset(theme, theme_params)

    case Repo.update(changeset) do
      {:ok, theme} ->
        conn
        |> put_flash(:info, "Theme updated successfully.")
        |> redirect(to: theme_path(conn, :show, theme.name))
      {:error, changeset} ->
        render(conn, "edit.html", theme: theme, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    theme = Repo.get_by!(Theme, name: id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(theme)

    conn
    |> put_flash(:info, "Theme deleted successfully.")
    |> redirect(to: theme_path(conn, :index))
  end
end
