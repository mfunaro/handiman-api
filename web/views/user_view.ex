defmodule HandimanApi.UserView do
  use HandimanApi.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, HandimanApi.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, HandimanApi.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      name: user.name,
      encrypted_password: user.encrypted_password,
      authentication_token: user.authentication_token}
  end
end
