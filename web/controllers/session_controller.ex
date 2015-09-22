defmodule HandimanApi.SessionController do
  use HandimanApi.Web, :controller

  def create(conn, %{"session" => session_params}) do
    case HandimanApi.Session.login(session_params, conn) do
      {:ok, user} ->
        conn
          |> put_status(:created)
          |> render(HandimanApi.UserView, "show.json", user: user)
      {:error, error_map} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(HandimanApi.ChangesetView, "error.json", changeset: error_map)
    end
  end

  def delete(conn, %{"session" => session_params}) do
    user = Repo.get_by(HandimanApi.User, %{email: session_params["email"]})
    user = %{user | authentication_token: ""}

    case HandimanApi.Repo.update(user) do
      {:ok, user} ->
        conn
          |> put_status(:ok)
          |> render(HandimanApi.UserView, "show.json", user: user)
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
          |> put_status(:unprocessable_entity)
          |> render(HandimanApi.ChangesetView, "error.json", changeset: %{message: "error logging out"})
    end
  end
end
