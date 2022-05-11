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

  @doc """
  get_rectangle!/1 return %Rectangle{} object for the give id.
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
  list_rectangle/0 returns all %Rectangle{} objects. Will return
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
  create_rectangle/1 will create %Rectangle{} object. Will return {:error, %Ecto.Changeset{}} error for invalid params.

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
  update_rectangle/1 will create %Rectangle{} object. Will return {:error, %Ecto.Changeset{}} error for invalid params.

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
    delete_rectangle/1 - delete %Rectangle{} object

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
  get_shape!/1 - returns %Shapes{} obj for give id.
  Raises `Ecto.NoResultsError` if Shapes doesn't exists.

  ### Expected

    * `id` - id of %Shapes{} obj


  ### Example

    iex(33)> Actions.get_shape!(3)
      %Ascii.Canvas.Shapes{}


    iex(35)> Actions.get_shape!(399)
      ** (Ecto.NoResultsError) expected at least one result but got none in query:
  """
  def get_shape!(id), do: Repo.get!(Shapes, id)

  @doc """
  create_shape/1 - creates %Shapes{} object.

  There is a belongs_to relations between %Rectangle{} and %Shapes{} schema.
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
  update_shape/1 - updates %Shapes{} object.

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
end
