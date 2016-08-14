defmodule DGUWeb.Session do
  alias DGUWeb.User

  def login(params, repo) do
    user = repo.get_by(User, username: String.downcase(params["username"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end

  def logged_in?(conn), do: !!conn.assigns[:current_user]

end