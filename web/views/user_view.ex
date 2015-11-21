defmodule HandimanApi.UserView do
  use HandimanApi.Web, :view
  use JSONAPI.PhoenixView

  alias HandimanApi.User

  def type, do: "user"

  def attributes(model) do
    # Calcaulte Handicap everytime we show the model.
    Map.merge(model,
      case User.calculate_handicap(User.round_count(model.id), model.id)  do
        {:ok, handicap} -> %{handicap: handicap}
        {:error, message} -> %{handicap: "N/A", error: message}
      end)
      |> Map.merge(%{course_count: User.unique_course_count(model.id)})
      |> Map.take([:id, :email, :name, :handicap, :error, :course_count])
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
