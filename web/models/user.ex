defmodule HandimanApi.User do
  use HandimanApi.Web, :model

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
    |> HandimanApi.Repo.insert!
  end

  def with_rounds(query) do 
    from q in query, preload: [:rounds]
  end


  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
