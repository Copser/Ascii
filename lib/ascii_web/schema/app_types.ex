defmodule AsciiWeb.Schema.AppTypes do
  @moduledoc """
  App Types module provides, objects, input objects and mutation for Ascii Canvas
  """
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  object :rectangle do
    field :id, :id
    field :name, :string

    field :collections, list_of(:shapes), resolve: fn %{id: id}, _, %{context: %{loader: loader}} ->
      loader
      |> Dataloader.load(:db, {:many, Ascii.Canvas.Shapes}, rectangle_id: id)
      |> on_load(fn loader ->
        res = Dataloader.get(loader, :db, {:many, Ascii.Canvas.Shapes}, rectangle_id: id)

        {:ok, res}
      end)
    end
  end

  object :shapes do
    field :id, :id
    field :coordinates, :json
    field :width, :integer
    field :height, :integer
    field :outline, :string
    field :fill, :string
  end

  input_object :rectangle_input do
    field :id, :id
    field :name, :string
  end

  input_object :shape_input do
    field :id, :id
    field :coordinates, list_of(:string)
    field :width, :integer
    field :height, :integer
    field :outline, :string
    field :fill, :string
    field :rectangle_id, :integer
  end

  object :app_mutations do
    field :create_rectangle, type: :rectangle do
      arg :rectangle, :rectangle_input

      resolve fn _, %{rectangle: rectangle}, _ ->
        Ascii.Actions.create_rectangle(rectangle)
      end
    end

    field :update_rectangle, type: :rectangle do
      arg :rectangle, :rectangle_input

      resolve fn _, %{rectangle: rectangle}, _ ->
        Ascii.Actions.update_rectangle(rectangle)
      end
    end

    field :delete_rectangle, type: :rectangle do
      arg :id, :id

      resolve fn _, %{id: id}, _ ->
        Ascii.Actions.delete_rectangle(id)
      end
    end

    field :create_shape, type: :shapes do
      arg :shape, :shape_input

      resolve fn _, %{shape: shape}, _ ->
        Ascii.Actions.create_shapes(shape)
      end
    end

    field :update_shape, type: :shapes do
      arg :shape, :shape_input

      resolve fn _, %{shape: shape}, _ ->
        Ascii.Actions.update_shape(shape)
      end
    end
  end
end
