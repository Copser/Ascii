defmodule Ascii.Repo.Migrations.CreateShapesSchema do
  use Ecto.Migration

  def change do
    create table(:shapes) do
      add :coordinates, {:array, :integer}, default: [20, 20]
      add :width, :integer, default: 10
      add :height, :integer, default: 10
      add :outline, :string, default: "none"
      add :fill, :string, default: "none"
      add :rectangle_id, references(:rectangles, on_delete: :delete_all)

      timestamps()
    end

    create index(:shapes, [:id])
    create index(:shapes, [:rectangle_id])
  end
end
