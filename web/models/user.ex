defmodule HandimanApi.User do
  use HandimanApi.Web, :model

  @differentials %{
    5 => 1,
    6 => 1,
    7 => 2,
    8 =>2,
    9 => 3,
    10 => 3,
    11 => 4,
    12 => 4,
    13 => 5,
    14 => 5,
    15 => 6,
    16 => 6,
    17 => 7,
    18 => 8,
    19 => 9,
    20 => 10
  }

  schema "users" do
    field :email, :string
    field :name, :string
    field :encrypted_password, :string
    field :authentication_token, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :rounds, HandimanApi.Round
    timestamps
  end

  @required_fields ~w(email name password password_confirmation)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email, on: HandimanApi.Repo, downcase: true)
    |> validate_length(:name, min: 1)
    |> validate_length(:password, min: 1)
    |> validate_length(:password_confirmation, min: 1)
    |> validate_confirmation(:password)
  end

  import Ecto.Changeset, only: [put_change: 3]

  @doc """
  Creates the user in the database with the password encrypted.
  """
  def create(changeset) do
    changeset
    |> put_change(:encrypted_password, hashed_password(changeset.params["password"]))
    |> HandimanApi.Repo.insert
  end

  def with_rounds(query) do
    from q in query, preload: [:rounds]
  end

  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

  @doc """
  Calculate a handicap for the user defined by the user_id. Use the count to determine the number of differentials to
  consider when calculating the handicap.
  """
  def calculate_handicap(count, user_id) do
    if count < 5 do
      {:error, "User needs more rounds before a handicap can be calculated"}
    else
      if count > 20, do: count = 20 # If the number of rounds is greater than 20 just use 20.
      num_differentials = @differentials[count]
      query = from u in HandimanApi.User,
              join: r in assoc(u, :rounds),
              where: r.user_id == u.id,
              where: u.id == "#{user_id}",
              select: r.differential,
              order_by: [desc: r.inserted_at],
              limit: "#{num_differentials}"
      diffs = HandimanApi.Repo.all(query)
      # TODO move sum into query.
      {_, diff_sum} = Enum.map_reduce(diffs, 0, fn(x, acc) -> {x, acc + x} end)
      {:ok, Float.floor((diff_sum/num_differentials) * 0.96, 1)}
    end
  end

  @doc """
  Get the number of rounds a user has.
  """
  def round_count(user_id) do
    query = from u in HandimanApi.User, join: r in assoc(u, :rounds), where: r.user_id == "#{user_id}", select: count(r.id)
    HandimanApi.Repo.one(query)
  end

  @doc """
  Get the number of unique courses the user has played.
  """
  def unique_course_count(user_id) do
    query = from u in HandimanApi.User,
            join: r in assoc(u, :rounds),
            join: t in assoc(r, :tee),
            join: c in assoc(t, :course),
            where: u.id == "#{user_id}", select: count(fragment("DISTINCT ?", c.name))
    HandimanApi.Repo.one(query)
  end

  def with_preloaded_assoc(user_id) do
    query = from u in HandimanApi.User,
            join: r in assoc(u, :rounds),
            join: t in assoc(r, :tee),
            join: c in assoc(t, :course),
            where: u.id == "#{user_id}", preload: [rounds: {r, tee: {t, rounds: r, course: c}}]
    HandimanApi.Repo.one(query)
  end
end
