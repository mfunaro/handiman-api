defmodule HandimanApi.RegistrationControllerTest do
  use HandimanApi.ConnCase

  alias HandimanApi.User
  @valid_attrs %{email: "some content", name: "some content", password: "password", password_confirmation: "password"}
  @query_attrs %{email: "some content", name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @valid_attrs
    assert json_response(conn, 201)["data"]["email"]
    assert json_response(conn, 201)["data"]["authentication_token"]
    assert Repo.get_by(User, @query_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
