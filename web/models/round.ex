defmodule HandimanApi.Round do
  use HandimanApi.Web, :model

  schema "rounds" do
    field :score, :integer
    field :holes, :integer
    field :differential, :float

    belongs_to :user, HandimanApi.User
    belongs_to :tee, HandimanApi.Tee
    timestamps
  end

  @required_fields ~w(score holes tee_id)
  @optional_fields ~w(user_id differential)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def with_user_and_tee(query) do
    from q in query, preload: [:tee, :user]
  end

  @doc """
  Preload the tee and the course for a round
  Round
    |> Round.with_course
    |> Repo.get!(id)
  """
  def with_course(query) do
    from q in query, preload: [tee: :course]
  end

  @doc """
  Calculate the differential for a round
  """
  def calc_differential(score, course_rating, slope_rating) do
    {float_score, _} = Float.parse(score)
    (float_score - course_rating) * 113 / slope_rating
  end
end
