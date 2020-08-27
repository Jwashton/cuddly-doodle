defmodule Todo.CsvImporter do
  def import(filename) do
    filename
    |> File.stream!()
    |> Stream.map(fn line -> String.trim_trailing(line) end)
    |> Stream.map(&parse_line/1)
    |> Stream.map(&build_entry/1)
    |> Todo.List.new()
  end

  defp parse_line(line) do
    [date, title] = String.split(line, ",")

    [year, month, day] =
      date
      |> String.split("/")
      |> Enum.map(&String.to_integer/1)

    {{year, month, day}, title}
  end

  defp build_entry({{year, month, day}, title}) do
    {:ok, date} = Date.new(year, month, day)

    %{
      date: date,
      title: title
    }
  end
end
