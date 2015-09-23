defmodule HandimanApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :name, :string
      add :encrypted_password, :string
      add :authentication_token, :string, size: 300

      timestamps
    end

  end
end
