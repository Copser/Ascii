defmodule AsciiWeb.Factory do
  import Ecto.Changeset
  alias Ascii.Repo
  alias Ascii.Canvas.Rectangle
  alias Ascii.Canvas.Shapes

  def create_canvas(:rectangle) do
    %{id: id} =
      %Rectangle{}
      |> Rectangle.changeset(%{name: "Sketch"})
      |> Repo.insert!()

    %Shapes{}
    |> Shapes.changeset(%{coordinates: ["10", "3"], width: 14, height: 6, outline: "X", fill: "O"})
    |> put_change(:rectangle_id, id)
    |> Repo.insert!()
  end

  def create_rectangle(:rectangle, attrs \\ %{}) do
    attrs = Map.merge(%{}, attrs)

    %Rectangle{}
    |> Rectangle.changeset(attrs)
    |> Repo.insert!()
  end
end
