defmodule HandimanApi.SessionControllerTest do
  use HandimanApi.ConnCase
  import Ecto.Changeset, only: [put_change: 3]

  alias HandimanApi.User
  @valid_attrs %{email: "email", password: "password"}
  @create_attrs %{email: "email", name: "name", password: "password", password_confirmation: "password"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    changeset = put_change(User.changeset(%User{}, @create_attrs), :encrypted_password, Comeonin.Bcrypt.hashpwsalt("password"))
    user = Repo.insert!(changeset)
    {:ok, conn: conn}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @valid_attrs
    assert json_response(conn, 201)["data"]["email"]
    assert json_response(conn, 201)["data"]["authentication_token"]
  end
end
