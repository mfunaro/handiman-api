defmodule HandimanApi.RoundView do
  use HandimanApi.Web, :view
  use JSONAPI.PhoenixView

  def type, do: "round"

  def attributes(model) do
    Map.take(model, [:id, :score, :holes, :differential])
  end

  def relationships() do
    %{
      user: %{
        view: HandimanApi.UserView
      },
      tee: %{
        view: HandimanApi.TeeView
      }
    }
  end

  def url_func() do
    &user_url/3
  end

  # def render("index.json", %{rounds: rounds}) do
  #   %{data: render_many(rounds, HandimanApi.RoundView, "round.json")}
  # end
  #
  # def render("show.json", %{round: round}) do
  #   %{data: render_one(round, HandimanApi.RoundView, "round.json")}
  # end
  #
  # def render("round.json", %{round: round}) do
  #   %{id: round.id,
  #     score: round.score,
  #     holes: round.holes,
  #     user_id: round.user_id,
  #     tee_id: round.tee_id,
  #     differential: round.differential}
  # end
end
