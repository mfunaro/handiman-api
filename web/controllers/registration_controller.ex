defmodule HandimanApi.RegistrationController do
  use HandimanApi.Web, :controller
  alias HandimanApi.User

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    if changeset.valid? do
      user = User.create(changeset)
      {:ok, user} = User.update_token(user, conn)
      conn
        |> render(HandimanApi.UserView, "show.json", user: user)
    else
      conn
        |> render(HandimanApi.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
