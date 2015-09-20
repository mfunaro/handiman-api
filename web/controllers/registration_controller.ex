defmodule HandimanApi.RegistrationController do
  use HandimanApi.Web, :controller
  alias HandimanApi.User

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    IO.inspect changeset
    if changeset.valid? do
      user = User.create(changeset)
      conn
        |> render(HandimanApi.UserView, "show.json", user: user)
    else
      conn
        |> render(HandimanApi.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
