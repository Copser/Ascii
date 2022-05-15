# Ascii

The project is built using
  * Elixir (1.13.4)
  * Erlang(24.3.3)
  * Phoenix 1.6.6
  * Node 12.22.7 (I guess any node 12+ will do)

# Setup
Install dependencies by running
  * `mix deps.get`

Create and migrate your database with 
  * `mix ecto.setup (seed is provided)`

# Graphql API

API is built using GrahpQL, query for listing rectangles and shapes is

```
  query ListRectangels {
    canvas {
      id
      name
      collections {
        id
        coordinates
        width
        height
        outline
        fill
      }
    }
  }
```

Mutations for CRUD operations are

```

mutation CreateRectangle($name: String) {
  createRectangle(rectangle: {
  	name: $name
  }) {
    id
  }
}

mutation UpdateRectangle($id: ID, $name: String) {
  updateRectangle(rectangle: {
    id: $id,
    name: $name,
  }) {
    id
  }
}

mutation CreateShape($coordinates: [Int], $width: Int, $height: Int, $fill: String, $outline: String, $rectangleId: Int) {
  createShape(shape: {
    coordinates: $coordinates,
    width: $width,
    height: $height,
    fill: $fill,
    outline: $outline,
    rectangleId: $rectangleId,
  }) {
    id
  }
}

mutation UpdateShape($id: ID, $coordinates: [Int], $width: Int, $height: Int, $fill: String, $outline: String) {
  updateShape(shape: {
    id: $id,
    coordinates: $coordinates,
    width: $width,
    height: $height,
    fill: $fill,
    outline: $outline,
  }) {
    id
  }
}

mutation DeleteRectangle($id: ID) {
  deleteRectangle(id: $id) {
    id
  }
}
```

# Tests

Test coverage is provided and can be run with 
  * `mix test`
