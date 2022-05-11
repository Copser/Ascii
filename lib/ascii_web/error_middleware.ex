defmodule AsciiWeb.ErrorMiddleware do
  @behaviour Absinthe.Middleware

  def call(resolution, _) do
    %{resolution |
      errors: Enum.flat_map(resolution.errors, &handle_error/1)
      }
  end

  defp get_error_text(t) when is_bitstring(t), do: t
  defp get_error_text(map) when is_map(map) do
    case Map.values(map) do
      [[value]] -> value
      _ -> ""
    end
  end

  defp format_error(list) do
    list
    |> Enum.map(&(get_error_text(&1)))
    |> Enum.filter(&(&1 != ""))
    |> Enum.join(", ")
  end

  defp handle_error(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {err, _opts} -> err end)
    |> Enum.map(fn({k,v}) -> "#{Phoenix.Naming.humanize(k)} #{format_error(v)}" end)
  end
  defp handle_error(error), do: [error]
end
