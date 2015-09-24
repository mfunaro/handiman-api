defmodule HandimanApi.CourseView do
  use HandimanApi.Web, :view
  use JSONAPI.PhoenixView

  def type, do: "course"

  def attributes(model) do
    Map.take(model, [:id, :name, :city, :state])
  end

  def relationships() do
    %{}
  end

  def url_func() do
    &user_url/3
  end
end
