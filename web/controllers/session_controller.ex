defmodule HandimanApi.SessionController do
  use HandimanApi.Web, :controller

  def create(conn, %{"session" => session_params}) do
    case HandimanApi.Session.login(session_params, conn) do
      {:ok, user} ->
        conn
          |> render(HandimanApi.UserView, "show.json", user: user)
      {:error, error_map} ->
        conn
          |> render(HandimanApi.ChangesetView, "error.json", changeset: error_map)
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end
end
