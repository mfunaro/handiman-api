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

  @required_fields ~w(score holes tee_id user_id differential)
  @optional_fields ~w()

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
end
