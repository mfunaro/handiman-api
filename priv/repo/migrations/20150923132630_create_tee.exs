defmodule HandimanApi.Repo.Migrations.CreateTee do
  use Ecto.Migration

  def change do
    create table(:tees) do
      add :name, :string
      add :course_rating, :integer
      add :slope_rating, :integer
      add :front_nine_course_rating, :float
      add :front_nine_slope_rating, :integer
      add :back_nine_course_rating, :float
      add :back_nine_slope_rating, :integer
      add :bogey_rating, :float
      add :gender, :string
      add :course_id, references(:courses)

      timestamps
    end
    create index(:tees, [:course_id, :gender, :name])

  end
end
