defmodule DGUWeb.SessionController do
  use DGUWeb.Web, :controller
  alias DGUWeb.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case DGUWeb.Registration.create(changeset, DGUWeb.Repo) do
      {:ok, _changeset} ->
        conn
        |> put_flash(:info, "Your account was created")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Unable to create account")
        |> render("new.html", changeset: changeset)
    end
  end

  def login_view(conn, _params) do
    render conn, "login.html"
  end

  def login(conn, %{"session" => session_params}) do
    case DGUWeb.Session.login(session_params, DGUWeb.Repo) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "Logged in")
        |> redirect(to: "/user")
      :error ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("login.html")
    end
  end

  def logout(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end

end