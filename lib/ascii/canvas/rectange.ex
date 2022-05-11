defmodule Ascii.Canvas.Rectangle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rectangles" do
    field :name, :string

    timestamps()
  end

  def changeset(rectangle, attrs) do
    rectangle
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
