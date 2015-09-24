defmodule HandimanApi.TeeControllerTest do
  use HandimanApi.ConnCase

  alias HandimanApi.Tee
  @valid_attrs %{back_nine_course_rating: "120.5", back_nine_slope_rating: 42, bogey_rating: "120.5", course_id: 42, course_rating: 42, front_nine_course_rating: "120.5", front_nine_slope_rating: 42, gender: "some content", name: "some content", slope_rating: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, tee_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    tee = Repo.insert! %Tee{}
    conn = get conn, tee_path(conn, :show, tee)
    assert json_response(conn, 200)["data"] == %{"id" => tee.id,
      "name" => tee.name,
      "course_rating" => tee.course_rating,
      "slope_rating" => tee.slope_rating,
      "front_nine_course_rating" => tee.front_nine_course_rating,
      "front_nine_slope_rating" => tee.front_nine_slope_rating,
      "back_nine_course_rating" => tee.back_nine_course_rating,
      "back_nine_slope_rating" => tee.back_nine_slope_rating,
      "bogey_rating" => tee.bogey_rating,
      "gender" => tee.gender,
      "course_id" => tee.course_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, tee_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, tee_path(conn, :create), tee: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Tee, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, tee_path(conn, :create), tee: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    tee = Repo.insert! %Tee{}
    conn = put conn, tee_path(conn, :update, tee), tee: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Tee, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    tee = Repo.insert! %Tee{}
    conn = put conn, tee_path(conn, :update, tee), tee: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    tee = Repo.insert! %Tee{}
    conn = delete conn, tee_path(conn, :delete, tee)
    assert response(conn, 204)
    refute Repo.get(Tee, tee.id)
  end
end
