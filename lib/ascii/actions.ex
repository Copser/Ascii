defmodule Ascii.Actions do
  @moduledoc """
  Actions module holds actions for CRUD operations, and queries.
  """
  import Ecto.Query
  import Ecto.Changeset
  alias Ascii.Canvas.Rectangle
  alias Ascii.Canvas.Shapes
  alias Ascii.Repo
  alias Ascii.Matrix

  @size {30, 30}

  ## Rectangle Actions

  @doc """
  get_rectangle!/1 return %Rectangle{} struct for the give id.
  Raises `Ecto.NoResultsError` if the Rectangle doesn't exist.

  ### Expected

    * `id` - rectangle id

  ### Example

    iex(4)> Actions.get_rectangle!(6)
      %Ascii.Canvas.Rectangle{}

    iex(7)> Actions.get_rectangle!(12)
      ** (Ecto.NoResultsError) expected at least one result but got none in query:
  """
  def get_rectangle!(id), do: Repo.get!(Rectangle, id)

  @doc """
  list_rectangle/0 returns all %Rectangle{} structs. Will return
  empty list if no objects created.

  ### Example

    iex(3)> Actions.list_rectangles
      [
        %Ascii.Canvas.Rectangle{},
        %Ascii.Canvas.Rectangle{},
      ]


    iex(3)> Actions.list_rectangles
      []
  """
  def list_rectangles do
    Rectangle
    |> order_by(desc: :id)
    |> Repo.all()
  end

  @doc """
  create_rectangle/1 will create %Rectangle{} struct. Will return {:error, %Ecto.Changeset{}} error for invalid params.

  ### Expected

    * `name` - string

  ### Example
    iex(14)> Actions.create_rectangle(%{name: "Example"})
      {:ok, %Ascii.Canvas.Rectangle{}}


    iex(15)> Actions.create_rectangle(%{name: ""})
      {:error, #Ecto.Changeset<>}
  """
  def create_rectangle(attrs) do
    %Rectangle{}
    |> Rectangle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  update_rectangle/1 will create %Rectangle{} struct. Will return {:error, %Ecto.Changeset{}} error for invalid params.

  ### Expected

    * `id` - rectangle id
    * `name` - string

  ### Example
    iex(19)> Actions.update_rectangle(%{name: "Testing", id: 7})
      {:ok, %Ascii.Canvas.Rectangle{}}


    iex(18)> Actions.update_rectangle(%{name: "", id: 7})
      {:error, #Ecto.Changeset<>}
  """
  def update_rectangle(attrs) do
    get_rectangle!(attrs.id)
    |> Rectangle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
    delete_rectangle/1 - delete %Rectangle{} struct

    ### Expected

      * `id` - id of %Rectangle{}


    ### Example

      iex(28)> Actions.delete_rectangle(7)
        {:ok, %Ascii.Canvas.Rectangle{}}
  """
  def delete_rectangle(id) do
    rectangle = get_rectangle!(id)

    Repo.delete(rectangle)
  end

  ## Shape Actions
  @doc """
  get_shape!/1 - returns %Shapes{} struct for give id.
  Raises `Ecto.NoResultsError` if Shapes doesn't exists.

  ### Expected

    * `id` - id of %Shapes{} struct


  ### Example

    iex(33)> Actions.get_shape!(3)
      %Ascii.Canvas.Shapes{}


    iex(35)> Actions.get_shape!(399)
      ** (Ecto.NoResultsError) expected at least one result but got none in query:
  """
  def get_shape!(id), do: Repo.get!(Shapes, id)


  @doc """
  list_shapes/1 - returns [%Shapes{}...] structs for given rectangle id.
  Will return empty list for non existing Rectangle id

  ### Expected

    * `rectangle_id` - created %Rectangle{} id, integer

  ### Example

    iex(4)> shapes = Actions.list_shapes(2)

      [
        %Ascii.Canvas.Shapes{},
        %Ascii.Canvas.Shapes{},
        %Ascii.Canvas.Shapes{}
      ]


    iex(5)> shapes = Actions.list_shapes(9)
      []
  """
  def list_shapes(rectangle_id) do
    Shapes
    |> where([t], t.rectangle_id == ^rectangle_id)
    |> Repo.all
  end

  @doc """
  create_shape/1 - creates %Shapes{} struct.

  There is a belongs_to relations between %Rectangle{} and %Shapes{} struct.
  If Rectangle id is not provided Ecto.NoResultsError is returned.

  If params are not provided it fill use default params.

  if invalid params not provied it returns {:error, #Ecto.Changeset<>}.

  ### Expected

    * `coordinates` - list of strings ["2", "3"], default []
    * `width` - integer / default 0
    * `height` - integer / default 0
    * `outline` - string / default "none"
    * `fill` - string / default "none"
    * `rectangle_id` - id of created rectangle


  ### Example

    iex(38)> Actions.create_shapes(%{coordinates: ["0", "10"], width: 3, height: 4, outline: "X", fill: "O", rectangle_id: rectangle.id})
        {:ok, %Ascii.Canvas.Shapes{}}

    iex(45)> Actions.create_shapes(%{coordinates: [1], width: 3, height: 4, outline: "X", fill: "O", rectangle_id: 3})
        ** (Ecto.NoResultsError) expected at least one result but got none in query:

    iex(45)> Actions.create_shapes(%{coordinates: [1], width: 3, height: 4, outline: "X", fill: "O", rectangle_id: 1})
        {:error, #Ecto.Changeset<>}
  """
  def create_shapes(attrs) do
    %{id: id} = get_rectangle!(attrs.rectangle_id)

    %Shapes{}
    |> Shapes.changeset(attrs)
    |> put_change(:rectangle_id, id)
    |> Repo.insert
  end

  @doc """
  update_shape/1 - updates %Shapes{} struct.

  Return error if invalid params not provied - {:error, #Ecto.Changeset<>}.

  ### Expected

    * `id` - shape id
    * `coordinates` - list of strings ["2", "3"], default []
    * `width` - integer / default 0
    * `height` - integer / default 0
    * `outline` - string / default "none"
    * `fill` - string / default "none"

  ### Example

    iex(49)> Actions.update_shape(%{id: 12, coordinates: ["1", "23"], width: 3, height: 4, outline: "X", fill: "O"})

      {:ok, %Ascii.Canvas.Shapes{}}


    iex(51)> Actions.update_shape(%{id: shape.id, coordinates: [2, "23"], width: 3, height: 4, outline: "X", fill: "O"})

      {:error, #Ecto.Changeset<>}
  """
  def update_shape(attrs) do
    get_shape!(attrs.id)
    |> Shapes.changeset(attrs)
    |> Repo.update
  end

  ### Draw Actions
  @doc """
  Returns start row based on coordinates
  """
  def start_row(rectangle), do: coordinates_to_map(rectangle).row

  @doc """
  Returns and end row of shape based on start row and height
  """
  def end_row(rectangle) do
    start_row(rectangle) + rectangle.height - 1
  end

  @doc """
    Returns a start column passed in the coordinates
  """
  def start_column(rectangle) do
    coordinates_to_map(rectangle).column
  end

  @doc """
    Returns a start column passed in the coordinates and width
  """
  def end_column(rectangle) do
    coordinates_to_map(rectangle).column + rectangle.width - 1
  end

  @doc """
    Returns the outline char for the rectangle passed in the struct.
    In case "none" is passed, it will fallback to the fill characted instead.
  """
  def outline_char(rectangle) do
    if rectangle.outline == "none", do: rectangle.fill, else: rectangle.outline
  end

  @doc """
    Returns the fill char for the rectangle passed in the struct.
    In case "none" is passed, it will fallback to the whitespace characted instead.
  """
  def fill_char(rectangle) do
    if rectangle.fill == "none", do: " ", else: rectangle.fill
  end

  @doc """
    draw()/1 generate ascii shapes for given params.
  """
  def draw(rectangles, flood_attrs \\ %{}) do
    generate_canvas(rectangles, flood_attrs) |> Enum.join("\n")
  end

  defp generate_canvas(rectangles, flood_attrs) when flood_attrs == %{} do
    generate_drawings(rectangles) |> Enum.reduce(&merge_drawings(&1, &2))
  end

  defp generate_canvas(rectangles, flood_attrs) do
    generate_canvas(rectangles, %{}) |> flood_fill(flood_attrs)
  end

  defp flood_fill(canvas, flood_attrs) do
    canvas
    |> equalize_rows()
    |> Matrix.from_list()
    |> fill_matrix(flood_attrs)
    |> Matrix.to_list()
  end

  defp generate_drawings(rectangles), do: rectangles |> Enum.map(&add_drawing/1)

  defp add_drawing(rectangle) do
    for row <- 0..end_row(rectangle), into: [], do: add_rows(row, rectangle)
  end

  defp add_rows(row, rectangle) do
    if row < start_row(rectangle), do: [], else: add_columns(row, rectangle)
  end

  defp add_columns(row, rectangle) do
    start_row = start_row(rectangle)
    end_row = end_row(rectangle)
    start_column = start_column(rectangle)
    end_column = end_column(rectangle)
    outline = outline_char(rectangle)
    fill = fill_char(rectangle)

    for column <- 0..end_column, into: [] do
      cond do
        column < start_column -> " "
        row == start_row or row == end_row -> outline
        column == start_column or column == end_column -> outline
        column > start_column and column < end_column -> fill
      end
    end
  end

  defp merge_drawings(rect1, rect2) do
    {total_rows, total_cols} = find_max_sizes(rect1, rect2)

    for row <- 0..total_rows, into: [] do
      rect1_row = rect1 |> Enum.at(row)
      rect2_row = rect2 |> Enum.at(row)

      cond do
        is_nil(rect1_row) -> rect2_row
        is_nil(rect2_row) -> rect1_row
        Enum.any?([rect1_row, rect2_row], &Enum.empty?/1) -> merge_empty_row(rect1_row, rect2_row)
        true -> merge_rows(rect1_row, rect2_row, total_cols)
      end
    end
  end

  defp find_max_sizes(list1, list2) do
    total_rows = ([Enum.count(list1), Enum.count(list2)] |> Enum.max()) - 1

    total_cols =
      ([
         list1 |> Enum.max_by(&Enum.count/1) |> Enum.count(),
         list2 |> Enum.max_by(&Enum.count/1) |> Enum.count()
       ]
       |> Enum.max()) - 1

    {total_rows, total_cols}
  end

  defp merge_empty_row(row1, row2) do
    cond do
      Enum.empty?(row1) and Enum.empty?(row2) -> []
      Enum.empty?(row1) -> row2
      true -> row1
    end
  end

  defp merge_rows(rect1_row, rect2_row, total_cols) do
    for column <- 0..total_cols, into: [] do
      rect1_col = rect1_row |> Enum.at(column)
      rect2_col = rect2_row |> Enum.at(column)

      cond do
        is_nil(rect1_col) and is_nil(rect2_col) -> ""
        is_nil(rect1_col) -> rect2_col
        is_nil(rect2_col) -> rect1_col
        true -> merge_columns(rect1_col, rect2_col)
      end
    end
  end

  defp merge_columns(col1, col2) when col1 == " ", do: col2
  defp merge_columns(col1, _col2), do: col1

  defp fill_matrix(matrix, %{"coordinates" => [start_column, start_row], "fill" => fill}) do
    matrix |> fill_fields(start_row, start_column, fill)
  end

  defp fill_fields(matrix, neighbours, _) when neighbours == [], do: matrix

  defp fill_fields(neighbours, matrix, fill) when is_list(neighbours) and is_map(matrix) do
    neighbours
    |> Enum.reduce(matrix, fn [row, col], acc -> acc |> put_in([row, col], fill) end)
    |> fill_fields(neighbours, fill)
  end

  defp fill_fields(matrix, neighbours, fill) do
    for [row, col] <- neighbours do
      find_neighbours(matrix, row, col)
    end
    |> Enum.concat()
    |> fill_fields(matrix, fill)
  end

  defp fill_fields(matrix, row, col, fill) do
    find_neighbours(matrix, row, col) |> fill_fields(matrix, fill)
  end

  defp find_neighbours(matrix, row, col) do
    potential_neighbours = [[row - 1, col], [row + 1, col], [row, col - 1], [row, col + 1]]
    {height, width} = @size

    for [r, c] <- potential_neighbours, into: [] do
      if r <= height and c <= width and Enum.member?([" ", ""], matrix[r][c]), do: [r, c]
    end
    |> Enum.reject(&is_nil/1)
  end

  defp equalize_rows(list) do
    total_rows = Enum.count(list) - 1
    max_cols = list |> Enum.max_by(&Enum.count/1) |> Enum.count()

    Enum.reduce(0..total_rows, list, fn index, list ->
      row = list |> Enum.at(index)
      cols = row |> Enum.count()
      missing_cols = max_cols - cols
      fillers = for _n when missing_cols > 0 <- 0..missing_cols, into: [], do: ""

      list |> List.replace_at(index, row ++ fillers)
    end)
  end

  def coordinates_to_map(%{coordinates: [column, row]}), do: %{column: column, row: row}
end
