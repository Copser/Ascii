defmodule Ascii.Canvas.Shapes do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ascii.Canvas.Rectangle

  schema "shapes" do
    field :coordinates, {:array, :integer}
    field :width, :integer
    field :height, :integer
    field :outline, :string
    field :fill, :string

    belongs_to :rectangle, Rectangle

    timestamps()
  end

  def changeset(shape, attrs) do
    shape
    |> cast(attrs, [:coordinates, :width, :height, :outline, :fill])
    |> validate_required([:coordinates, :width, :height, :outline, :fill])
  end
end
