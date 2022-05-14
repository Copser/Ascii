defmodule AsciiWeb.MutationTest do
  use AsciiWeb.ConnCase
  alias AsciiWeb.Factory

  describe "CRUD rectangle" do

    @create_rectangle_mutation"""
      mutation CreateRectangle($name: String) {
        createRectangle(rectangle: {
          name: $name
        }) {
          name
        }
      }
    """

    @update_rectangle_mutation"""
      mutation UpdateRectangle($name: String, $id: ID) {
        updateRectangle(rectangle: {
          id: $id,
          name: $name,
        }) {
          id
          name
        }
      }
    """

    @delete_rectangle_mutation"""
      mutation DeleteRectangle($id: ID) {
        deleteRectangle(id: $id) {
          id
        }
      }
    """

    test "mutation: create rectangle", %{conn: conn} do
      conn =
        post(conn, "/api", %{
          "query" => @create_rectangle_mutation,
          "variables" => %{name: "Test"}
        })

      assert json_response(conn, 200) == %{"data" => %{
        "createRectangle" => %{
          "name" => "Test"
        }
      }}
    end

    test "mutation: create rectangle with invalid attrs return changeset error", %{conn: conn} do
      conn =
        post(conn, "/api", %{
          "query" => @create_rectangle_mutation,
          "variables" => %{name: ""}
        })

      assert json_response(conn, 200) == %{"data" => %{
        "createRectangle" => nil,
        },
        "errors" => [
          %{
            "locations" => [
              %{
                "column" => 5,
                "line" => 2
              }
            ],
            "message" => "Name can't be blank",
            "path" => [
              "createRectangle"
            ]
          }
        ]
      }
    end

    test "mutation: update rectangle with valid params", %{conn: conn} do
      %{id: id} = AsciiWeb.Factory.create_rectangle(:rectangle, %{name: "Sketch"})

      conn =
        post(conn, "/api", %{
          "query" => @update_rectangle_mutation,
          "variables" => %{name: "Update Sketch", id: id}
        })

      assert json_response(conn, 200) == %{"data" => %{
        "updateRectangle" => %{
          "name" => "Update Sketch",
          "id" => "#{id}"
        }
      }}
    end

    test "mutation: update with invalid params returns changeset error", %{conn: conn} do
      %{id: id} = Factory.create_rectangle(:rectangle, %{name: "Sketch"})

      conn =
        post(conn, "/api", %{
          "query" => @update_rectangle_mutation,
          "variables" => %{name: "", id: id}
        })

      assert json_response(conn, 200) == %{"data" => %{
        "updateRectangle" => nil,
        },
        "errors" => [
          %{
            "locations" => [
              %{
                "column" => 5,
                "line" => 2
              }
            ],
            "message" => "Name can't be blank",
            "path" => [
              "updateRectangle"
            ]
          }
        ]
      }
    end

    test "mutation: delete rectangle", %{conn: conn} do
      %{id: id} = Factory.create_rectangle(:rectangle, %{name: "Sketch"})

      conn =
        post(conn, "/api", %{
          "query" => @delete_rectangle_mutation,
          "variables" => %{id: id}
        })

      assert json_response(conn, 200) == %{"data" => %{
        "deleteRectangle" => %{
          "id" => "#{id}"
        }
      }}
    end
  end

  describe "CRUD Shapes" do

    @create_shape"""
      mutation CreateShape($coordinates: [String], $width: Int, $height: Int, $fill: String, $outline: String, $rectangleId: ID) {
        createShape(shape: {
          coordinates: $coordinates,
          width: $width,
          height: $height,
          fill: $fill,
          outline: $outline,
          rectangleId: $rectangleId,
        }) {
          coordinates
          width
          height
          fill
          outline
        }
      }
    """

    @update_shape"""
      mutation UpdateShape($id: ID, $coordinates: [String], $width: Int, $height: Int, $fill: String, $outline: String) {
        updateShape(shape: {
          id: $id
          coordinates: $coordinates,
          width: $width,
          height: $height,
          fill: $fill,
          outline: $outline,
        }) {
          id
          coordinates
          width
          height
          fill
          outline
        }
      }
    """

    test "mutation: create shape", %{conn: conn} do
      %{id: id} = Factory.create_rectangle(:rectangle, %{name: "Sketch"})

      conn =
        post(conn, "/api", %{
          "query" => @create_shape,
          "variables" => %{coordinates: [1, 2], width: 4, height: 2, fill: "~", outline: "*", rectangleId: id}
        })

      assert json_response(conn, 200) == %{"data" => %{
        "createShape" => %{
          "coordinates" => [1, 2],
          "width" => 4,
          "height" => 2,
          "fill" => "~",
          "outline" => "*"
        }
      }}
    end

    test "mutation: update shape", %{conn: conn} do
      %{id: id} = Factory.create_canvas(:rectangle)

      conn =
        post(conn, "/api", %{
          "query" => @update_shape,
          "variables" => %{id: id, coordinates: [10, 20], width: 40, height: 20, fill: "~", outline: "*"}
        })

      assert json_response(conn, 200) == %{"data" => %{
        "updateShape" => %{
          "id" => "#{id}",
          "coordinates" => [10, 20],
          "width" => 40,
          "height" => 20,
          "fill" => "~",
          "outline" => "*"
        }
      }}
    end
  end
end
