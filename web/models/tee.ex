defmodule HandimanApi.Tee do
  use HandimanApi.Web, :model

  schema "tees" do
    field :name, :string
    field :course_rating, :integer
    field :slope_rating, :integer
    field :front_nine_course_rating, :float
    field :front_nine_slope_rating, :integer
    field :back_nine_course_rating, :float
    field :back_nine_slope_rating, :integer
    field :bogey_rating, :float
    field :gender, :string
    field :course_id, :integer

    timestamps
  end

  @required_fields ~w(name course_rating slope_rating front_nine_course_rating front_nine_slope_rating back_nine_course_rating back_nine_slope_rating bogey_rating gender course_id)
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
