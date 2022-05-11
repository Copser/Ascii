defmodule Ascii.Repo.Migrations.CreateShapesSchema do
  use Ecto.Migration

  def change do
    create table(:shapes) do
      add :coordinates, {:array, :string}, default: []
      add :width, :integer, default: 0
      add :height, :integer, default: 0
      add :outline, :string, default: "none"
      add :fill, :string, default: "none"
      add :rectangle_id, references(:rectangles, on_delete: :delete_all)

      timestamps()
    end

    create index(:shapes, [:id])
    create index(:shapes, [:rectangle_id])
  end
end
