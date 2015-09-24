defmodule HandimanApi.TeeController do
  use HandimanApi.Web, :controller

  alias HandimanApi.Tee

  plug :scrub_params, "tee" when action in [:create, :update]

  def index(conn, _params) do
    tees = Repo.all(Tee)
    render(conn, "index.json", tees: tees)
  end

  def create(conn, %{"tee" => tee_params}) do
    changeset = Tee.changeset(%Tee{}, tee_params)

    case Repo.insert(changeset) do
      {:ok, tee} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", tee_path(conn, :show, tee))
        |> render("show.json", tee: tee)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HandimanApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tee = Repo.get!(Tee, id)
    render conn, "show.json", tee: tee
  end

  def update(conn, %{"id" => id, "tee" => tee_params}) do
    tee = Repo.get!(Tee, id)
    changeset = Tee.changeset(tee, tee_params)

    case Repo.update(changeset) do
      {:ok, tee} ->
        render(conn, "show.json", tee: tee)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HandimanApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tee = Repo.get!(Tee, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(tee)

    send_resp(conn, :no_content, "")
  end
end
