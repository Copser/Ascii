defmodule AsciiWeb.Schema do
  use Absinthe.Schema

  import_types AsciiWeb.Schema.Types.ScalarTypes
  import_types AsciiWeb.Schema.AppTypes

  query do
    field :canvas, list_of(:rectangle) do
      resolve fn _, _, _ ->
        {:ok, Ascii.Actions.list_rectangles}
      end
    end
  end

  mutation do
    import_fields :app_mutations
  end

  def context(ctx) do
    source = Dataloader.Ecto.new(Ascii.Repo)

    loader =
      Dataloader.new
      |> Dataloader.add_source(:db, source)

    Map.put(ctx, :loader, loader)
  end


  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [AsciiWeb.ErrorMiddleware]
  end

  def middleware(middleware, _field, _object), do: middleware
end
