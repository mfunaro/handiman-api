defmodule HandimanApi.SessionController do
  use HandimanApi.Web, :controller

  def create(conn, %{"session" => session_params}) do
    case HandimanApi.Session.login(session_params, conn) do
      {{:ok, jwt, full_claims}, conn} ->
        conn
          |> put_resp_header("authorization", jwt)
          |> put_status(:created)
          |> render(HandimanApi.UserView, "show.json", %{data: Guardian.Plug.current_resource(conn), conn: conn})
      {:error, reason} ->
        conn
          |> put_status(:unauthorized)
          |> render(HandimanApi.ChangesetView, "error.json", changeset: %{message: "unauthorized"})
    end
  end

  def delete(conn, %{"session" => session_params}) do
    IO.inspect session_params
    user = Repo.get_by(HandimanApi.User, %{email: session_params["email"]})
    case Guardian.Plug.claims(conn) do
      {:ok, claims} ->
        case  Guardian.revoke!(Guardian.Plug.current_token(conn), claims) do
          :ok ->
            conn
              |> put_status(:ok)
              |> render(HandimanApi.UserView, "show.json", %{data: user, conn: conn})
          {:error, reason} ->
            conn
              |> put_status(:unprocessable_entity)
              |> render(HandimanApi.ChangesetView, "error.json", changeset: %{message: reason})
        end
      {:error, message} ->
        conn
          |> put_status(:unauthorized)
          |> render(HandimanApi.ChangesetView, "error.json", changeset: %{message: message})
    end
  end
end
