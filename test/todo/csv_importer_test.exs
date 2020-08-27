defmodule Todo.CsvImporterTest do
  use ExUnit.Case, async: true

  test "can import a todo list" do
    todo_list = Todo.CsvImporter.import("./todos.csv")

    entries =
      todo_list
      |> Todo.List.entries(~D[2018-12-19])
      |> Enum.map(& &1.title)

    assert entries == ["Dentist", "Movies"]
  end
end
