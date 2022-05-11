defmodule AsciiWeb.QueriesTest do
  use AsciiWeb.ConnCase
  alias AsciiWeb.Factory

  describe "GET rectangles" do

    @rectangle"""
      query ListRectangels {
        canvas {
          name
          collections {
            coordinates
            width
            height
            outline
            fill
          }
        }
      }
    """

    test "query: canvas", %{conn: conn} do
      Factory.create_canvas(:rectangle)

      conn =
        get(conn, "/api", %{
          "query" => @rectangle,
        })

      assert json_response(conn, 200) == %{"data" => %{"canvas" => [%{
        "collections" => [
          %{
            "coordinates" => [
              "10",
              "3"
            ],
            "fill" => "O",
            "height" => 6 ,
            "outline" => "X",
            "width" => 14
          }
        ],
        "name" => "Sketch"
      }]}}
    end
  end
end
