defmodule HandimanApi.RoundController do
  use HandimanApi.Web, :controller

  alias HandimanApi.Round
  alias HandimanApi.Tee

  plug :scrub_params, "round" when action in [:create, :update]

  def index(conn, _params) do
    rounds = Repo.all(Round)
    render(conn, "index.json", %{data: rounds, conn: conn})
  end

  def create(conn, %{"round" => round_params, "user" => user_id}) do
    changeset = Round.changeset(%Round{}, round_params) # Check if the round_params are valid
    tee = Repo.get!(Tee, round_params["tee_id"])
    diff = Round.calc_differential(round_params["score"], tee.course_rating, tee.slope_rating)
      |> Float.round(2)
    changeset = Round.changeset(%Round{}, Map.merge(round_params, %{"user_id"=> user_id, "differential"=> diff}))
    case Repo.insert(changeset) do
      {:ok, round} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_round_path(conn, :show, round))
        |> render("show.json", %{data: round, conn: conn})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HandimanApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    round = Round
      |> Round.with_user_and_tee
      |> Repo.get!(id)
    render conn, "show.json",  %{data: round, conn: conn}
  end

  def update(conn, %{"id" => id, "round" => round_params}) do
    round = Repo.get!(Round, id)
    changeset = Round.changeset(round, round_params)

    case Repo.update(changeset) do
      {:ok, round} ->
        render(conn, "show.json", %{data: round, conn: conn})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(HandimanApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    round = Repo.get!(Round, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(round)

    send_resp(conn, :no_content, "")
  end
end
