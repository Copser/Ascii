defmodule Ascii.ActionsTest do
  use Ascii.DataCase

  alias Ascii.Actions
  alias AsciiWeb.Factory

  describe "rectangle" do
    @valid_attrs %{name: "test"}
    @update_attrs %{name: "New Sketch"}
    @invalid_attrs %{name: ""}

    def rectangle_fixture(attrs \\ %{}) do
      attrs
      |> Enum.into(attrs)
      |> Actions.create_rectangle()
    end

    test "list_rectangles/0 return all rectangles" do
      {:ok, rectangle} = rectangle_fixture(@valid_attrs)
      assert Actions.list_rectangles() == [rectangle]
    end

    test "get_rectangle!/1 return rectangle for given id" do
      {:ok, rectangle} = rectangle_fixture(@valid_attrs)
      assert Actions.get_rectangle!(rectangle.id) == rectangle
    end

    test "create_rectangle/1 with valida data create rectangle" do
      {:ok, rectangle} = Actions.create_rectangle(@valid_attrs)

      assert rectangle.name == @valid_attrs.name
    end

    test "create_rectangle/1 with invalid data return changeset error" do
      assert {:error, %Ecto.Changeset{}} = Actions.create_rectangle(@invalid_attrs)
    end

    test "update_rectangle/1 with valid data updates rectangle" do
      {:ok, rectangle} = rectangle_fixture(@valid_attrs)

      attrs = Map.merge(@update_attrs, %{id: rectangle.id})
      {:ok, %{name: name}} = Actions.update_rectangle(attrs)

      assert name == @update_attrs.name
    end

    test "update_rectangle/1 with invalid data return changeset error" do
      {:ok, rectangle} = rectangle_fixture(@valid_attrs)

      attrs = Map.merge(@invalid_attrs, %{id: rectangle.id})
      assert {:error, %Ecto.Changeset{}} = Actions.update_rectangle(attrs)
    end

    test "delete_rectangle/1 return rectangle changeset" do
      {:ok, rectangle} = rectangle_fixture(@valid_attrs)

      assert rectangle = Actions.delete_rectangle(rectangle.id)
    end
  end

  describe "shapes" do
    @valid_attrs %{coordinates: [5, 5], width: 5, height: 10, outline: "none", fill: "O"}
    @update_attrs %{coordinates: [0, 0], width: 15, height: 10, outline: "X", fill: "O"}
    @invalid_attrs %{coordinates: ["0", "0"], width: 15, height: 10, fill: "O"}

    def shape_fixure(attrs) do
      attrs
      |> Enum.into(attrs)
      |> Actions.create_shapes()
    end

    test "get_shape/1 return shape for give id" do
      %{id: id} = create_rectangle()
      attrs = Map.merge(@valid_attrs, %{rectangle_id: id})
      {:ok, shape} = shape_fixure(attrs)

      assert Actions.get_shape!(shape.id) == shape
    end

    test "create_shape/1 with valid data create shape" do
      %{id: id} = create_rectangle()
      attrs = Map.merge(@valid_attrs, %{rectangle_id: id})
      {:ok, shape} = Actions.create_shapes(attrs)

      assert shape.coordinates == @valid_attrs.coordinates
      assert shape.rectangle_id == id
    end

    test "create_shape/1 with invalid data return changeset error" do
      %{id: id} = create_rectangle()
      attrs = Map.merge(@invalid_attrs, %{rectangle_id: id})

      assert {:error, %Ecto.Changeset{}} = Actions.create_shapes(attrs)
    end

    test "update_shape/1 with valid data updates shape" do
      %{id: id} = create_rectangle()
      attrs = Map.merge(@valid_attrs, %{rectangle_id: id})
      {:ok, shape} = Actions.create_shapes(attrs)

      attrs = Map.merge(@update_attrs, %{id: shape.id})
      {:ok, shape} = Actions.update_shape(attrs)

      assert shape.coordinates == @update_attrs.coordinates
      assert shape.rectangle_id == id
    end
  end

  describe "draw fixure" do
    test "draw first set of shapes" do
      shapes = Factory.create_test_fixture_one(:canvas)

      assert Actions.draw(shapes) |> String.trim ==
        """

           @@@@@
           @XXX@  XXXXXXXXXXXXXX
           @@@@@  XOOOOOOOOOOOOX
                  XOOOOOOOOOOOOX
                  XOOOOOOOOOOOOX
                  XOOOOOOOOOOOOX
                  XXXXXXXXXXXXXX
        """
        |> String.trim
    end

    test "draw second set of shapes" do
      shapes = Factory.create_test_fixure_two(:canvas)

      assert Actions.draw(shapes) |> String.trim ==
        """
                      .......
                      .......
                      .......
        OOOOOOOO      .......
        O      O      .......
        O    XXXXX    .......
        OOOOOXXXXX
             XXXXX
        """
        |> String.trim()
    end
  end
end
