defmodule Ascii.Canvas.Shapes do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ascii.Canvas.Rectangle

  schema "shapes" do
    field :coordinates, {:array, :string}, default: []
    field :width, :integer, default: 0
    field :height, :integer, default: 0
    field :outline, :string, default: "none"
    field :fill, :string, default: "none"

    belongs_to :rectangle, Rectangle

    timestamps()
  end

  def changeset(shape, attrs) do
    shape
    |> cast(attrs, [:coordinates, :width, :height, :outline, :fill])
    |> validate_required([:coordinates, :width, :height, :outline, :fill])
  end
end
