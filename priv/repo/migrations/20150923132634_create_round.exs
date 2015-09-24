defmodule HandimanApi.Repo.Migrations.CreateRound do
  use Ecto.Migration

  def change do
    create table(:rounds) do
      add :score, :integer
      add :holes, :integer
      add :differential, :float
      add :user_id, references(:users)
      add :tee_id, references(:tees)

      timestamps
    end
    create index(:rounds, [:user_id])
  end
end
