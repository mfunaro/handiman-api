defmodule HandimanApi.UserView do
  use HandimanApi.Web, :view
  use JSONAPI.PhoenixView

  def type, do: "user"

  def attributes(model) do
    Map.take(model, [:id, :email, :name])
  end

  def relationships() do
    %{
      rounds: %{
        view: HandimanApi.RoundView
      }
    }
  end

  def url_func() do
    &user_url/3
  end
end
