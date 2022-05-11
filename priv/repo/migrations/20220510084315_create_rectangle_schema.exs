defmodule Ascii.Repo.Migrations.CreateRectangleSchema do
  use Ecto.Migration

  def change do
    create table(:rectangles) do
      add :name, :string

      timestamps()
    end

    create index(:rectangles, [:id, :name])
  end
end
