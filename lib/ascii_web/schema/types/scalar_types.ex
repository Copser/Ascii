defmodule AsciiWeb.Schema.Types.ScalarTypes do
  use Absinthe.Schema.Notation

  scalar :date, name: "Date" do
    description """
    The `DateTime` scalar type represents a date and time in the UTC
    timezone. The DateTime appears in a JSON response as an ISO8601 formatted
    string, including UTC timezone ("Z"). The parsed date should be in UTC zone.
    """

    serialize fn date -> Date.to_iso8601(date) <> "Z" end
    parse &parse_datetime/1
  end


  defp parse_datetime(%Absinthe.Blueprint.Input.String{value: value}) do
    case Date.from_iso8601(value) do
      {:ok, naive_datetime} -> {:ok, naive_datetime}
      _error -> :error
    end
  end

  defp parse_datetime(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_datetime(_) do
    :error
  end

  scalar :datetime, name: "DateTime" do
    description """
    The `DateTime` scalar type represents a date and time in the UTC
    timezone. The DateTime appears in a JSON response as an ISO8601 formatted
    string, including UTC timezone ("Z"). The parsed date should be in UTC zone.
    """

    serialize fn date -> NaiveDateTime.to_iso8601(date) <> "Z" end
    parse &parse_naive_datetime/1
  end


  defp parse_naive_datetime(%Absinthe.Blueprint.Input.String{value: value}) do
    case NaiveDateTime.from_iso8601(value) do
      {:ok, naive_datetime} -> {:ok, naive_datetime}
      _error -> :error
    end
  end

  defp parse_naive_datetime(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_naive_datetime(_) do
    :error
  end

  scalar :json, name: "Json" do
    description("""
    The `Json` scalar type represents arbitrary json string data, represented as UTF-8
    character sequences. The Json type is most often used to represent a free-form
    human-readable json string.
    """)

    serialize(&encode/1)
    parse(&decode/1)
  end

  @spec decode(Absinthe.Blueprint.Input.String.t()) :: {:ok, term()} | :error
  @spec decode(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp decode(%Absinthe.Blueprint.Input.String{value: value}) do
    case Jason.decode(value) do
      {:ok, result} -> {:ok, result}
      _ -> :error
    end
  end

  defp decode(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp decode(_) do
    :error
  end

  defp encode(value), do: value
end
