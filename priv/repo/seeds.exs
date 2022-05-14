# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ascii.Repo.insert!(%Ascii.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Ecto.Changeset
alias Ascii.Canvas.Rectangle
alias Ascii.Canvas.Shapes
alias Ascii.Repo

figure_one =
  %Rectangle{}
  |> Rectangle.changeset(%{name: "Figure 1"})
  |> Repo.insert!()

figure_two =
  %Rectangle{}
  |> Rectangle.changeset(%{name: "Figure 2"})
  |> Repo.insert!()

### Figure one Shapes
%Shapes{}
|> Shapes.changeset(%{coordinates: [3, 2], width: 5, height: 3, outline: "@", fill: "X"})
|> put_change(:rectangle_id, figure_one.id)
|> Repo.insert!()

%Shapes{}
|> Shapes.changeset(%{coordinates: [10, 3], width: 14, height: 6, outline: "X", fill: "O"})
|> put_change(:rectangle_id, figure_one.id)
|> Repo.insert!()


### Figure Two Shapes
%Shapes{}
|> Shapes.changeset(%{coordinates: [14, 0], width: 7, height: 6, outline: "none", fill: "."})
|> put_change(:rectangle_id, figure_two.id)
|> Repo.insert!()

%Shapes{}
|> Shapes.changeset(%{coordinates: [0, 3], width: 8, height: 4, outline: "O", fill: "none"})
|> put_change(:rectangle_id, figure_two.id)
|> Repo.insert!()

%Shapes{}
|> Shapes.changeset(%{coordinates: [5, 5], width: 5, height: 3, outline: "X", fill: "X"})
|> put_change(:rectangle_id, figure_two.id)
|> Repo.insert!()
