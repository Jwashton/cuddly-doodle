defmodule Todo.ListTest do
  use ExUnit.Case
  doctest Todo.List

  setup do
    todo_list =
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2018-12-19], title: "Dentist"})
      |> Todo.List.add_entry(%{date: ~D[2018-12-20], title: "Shopping"})
      |> Todo.List.add_entry(%{date: ~D[2018-12-19], title: "Movies"})

    %{todo_list: todo_list}
  end

  test "retrieves entries for Dec 19", context do
    dec_19_entries =
      Todo.List.entries(context.todo_list, ~D[2018-12-19])
      |> Enum.map(& &1.title)

    assert dec_19_entries == ["Dentist", "Movies"]
  end

  test "retrieves entries for Dec 18", context do
    dec_18_entries = Todo.List.entries(context.todo_list, ~D[2018-12-18])
    assert dec_18_entries == []
  end

  test "updates an entry", context do
    entries =
      context.todo_list
      |> Todo.List.update_entry(1, &Map.put(&1, :date, ~D[2019-12-20]))
      |> Todo.List.entries(~D[2019-12-20])
      |> Enum.map(& &1.title)

    assert entries == ["Dentist"]
  end

  test "deletes an entry", context do
    entries =
      context.todo_list
      |> Todo.List.delete_entry(1)
      |> Todo.List.entries(~D[2018-12-19])
      |> Enum.map(& &1.title)

    assert entries == ["Movies"]
  end

  test "creating a todo.list from a list of entries" do
    todo_list =
      Todo.List.new([
        %{date: ~D[2018-12-19], title: "Dentist"},
        %{date: ~D[2018-12-20], title: "Shopping"},
        %{date: ~D[2018-12-19], title: "Movies"}
      ])

    entries =
      todo_list
      |> Todo.List.entries(~D[2018-12-19])
      |> Enum.map(& &1.title)

    assert entries == ["Dentist", "Movies"]
  end
end
