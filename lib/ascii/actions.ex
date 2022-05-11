defmodule Ascii.Actions do
  @moduledoc """
  Actions module holds actions for CRUD operations, and queries.
  """
  import Ecto.Query
  import Ecto.Changeset
  alias Ascii.Canvas.Rectangle
  alias Ascii.Canvas.Shapes
  alias Ascii.Repo

  ## Rectangle Actions
  def get_rectangle!(id), do: Repo.get!(Rectangle, id)

  def list_rectangles do
    Rectangle
    |> order_by(desc: :id)
    |> Repo.all()
  end

  def create_rectangle(attrs) do
    %Rectangle{}
    |> Rectangle.changeset(attrs)
    |> Repo.insert()
  end

  def update_rectangle(attrs) do
    get_rectangle!(attrs.id)
    |> Rectangle.changeset(attrs)
    |> Repo.update()
  end

  def delete_rectangle(id) do
    rectangle = get_rectangle!(id)

    Repo.delete(rectangle)
  end

  ## Shape Actions
  def get_shape!(id), do: Repo.get!(Shapes, id)

  def create_shapes(attrs) do
    %{id: id} = get_rectangle!(attrs.rectangle_id)

    %Shapes{}
    |> Shapes.changeset(attrs)
    |> put_change(:rectangle_id, id)
    |> Repo.insert
  end

  def update_shape(attrs) do
    get_shape!(attrs.id)
    |> Shapes.changeset(attrs)
    |> Repo.update
  end
end
