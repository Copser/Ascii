defmodule AsciiWeb.Factory do
  import Ecto.Changeset
  alias Ascii.Repo
  alias Ascii.Canvas.Rectangle
  alias Ascii.Canvas.Shapes
  alias Ascii.Actions

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

  def create_test_fixture_one(:canvas) do
    %{id: id} =
      %Rectangle{}
      |> Rectangle.changeset(%{name: "Test Fixure one"})
      |> Repo.insert!()

    attrs = [
      %{coordinates: [3, 2], width: 5, height: 3, outline: "@", fill: "X", rectangle_id: id},
      %{coordinates: [10, 3], width: 14, height: 6, outline: "X", fill: "O", rectangle_id: id}
    ]

    attrs
    |> Enum.map(fn t ->
      {:ok, shapes} =
        Actions.create_shapes(t)

      shapes
    end)
  end

  def create_test_fixure_two(:canvas) do
    %{id: id} =
      %Rectangle{}
      |> Rectangle.changeset(%{name: "Test Fixure two"})
      |> Repo.insert!()

    attrs = [
      %{coordinates: [14, 0], width: 7, height: 6, outline: "none", fill: ".", rectangle_id: id},
      %{coordinates: [0, 3], width: 8, height: 4, outline: "O", fill: "none", rectangle_id: id},
      %{coordinates: [5, 5], width: 5, height: 3, outline: "X", fill: "X", rectangle_id: id}
    ]

    attrs
    |> Enum.map(fn t ->
      {:ok, shapes} = Actions.create_shapes(t)

      shapes
    end)
  end
end
