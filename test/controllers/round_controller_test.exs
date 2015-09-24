defmodule HandimanApi.RoundControllerTest do
  use HandimanApi.ConnCase

  alias HandimanApi.Round
  @valid_attrs %{differential: "120.5", holes: 42, score: 42, tee_id: 42, user_id: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, round_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = get conn, round_path(conn, :show, round)
    assert json_response(conn, 200)["data"] == %{"id" => round.id,
      "score" => round.score,
      "holes" => round.holes,
      "user_id" => round.user_id,
      "tee_id" => round.tee_id,
      "differential" => round.differential}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, round_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, round_path(conn, :create), round: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Round, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, round_path(conn, :create), round: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = put conn, round_path(conn, :update, round), round: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Round, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = put conn, round_path(conn, :update, round), round: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = delete conn, round_path(conn, :delete, round)
    assert response(conn, 204)
    refute Repo.get(Round, round.id)
  end
end
