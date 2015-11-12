defmodule HandimanApi.UserController do
  use HandimanApi.Web, :controller

  alias HandimanApi.User

  plug :scrub_params, "data" when action in [:create, :update]
  # plug Guardian.Plug.EnsureAuthenticated, on_failure: { HandimanApi.PageController, :unauthenticated_api }


  def index(conn, _params) do
    users = User |> User.with_rounds |> Repo.all
    render(conn, "index.json", %{data: users, conn: conn})
  end

  def create(conn, %{"data" => %{ "attributes" => user_params}}) do
    changeset = User.changeset(%User{}, user_params)

    case User.create(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", %{data: user, conn: conn})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HandimanApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = User.with_preloaded_assoc(id)
    render conn, "show.json",  %{data: user, conn: conn}
  end

  def update(conn, %{"id" => id, "data" => %{ "attributes" => user_params}}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", %{data: user, conn: conn})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HandimanApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
