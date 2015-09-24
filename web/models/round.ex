defmodule HandimanApi.Round do
  use HandimanApi.Web, :model

  schema "rounds" do
    field :score, :integer
    field :holes, :integer
    field :user_id, :integer
    field :tee_id, :integer
    field :differential, :float

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
end
