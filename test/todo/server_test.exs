defmodule Todo.ServerTest do
  use ExUnit.Case

  defmodule MockDatabase do
    def store(_key, _data), do: nil
    def get(_key), do: nil
  end

  setup do
    {:ok, server} = start_supervised(Todo.Server, start: {Todo.Server, :start_link, [MockDatabase, "alice"]})

    Todo.Server.add_entry(server, %{date: ~D[2018-12-19], title: "Dentist"})
    Todo.Server.add_entry(server, %{date: ~D[2018-12-20], title: "Shopping"})
    Todo.Server.add_entry(server, %{date: ~D[2018-12-19], title: "Movies"})

    %{server: server}
  end

  test "Getting entries by day", %{server: server} do
    entries =
      server
      |> Todo.Server.entries(~D[2018-12-19])
      |> Enum.map(& &1.title)

    assert entries == ["Dentist", "Movies"]
  end

  test "Updating an entry", %{server: server} do
    Todo.Server.update_entry(server, 1, &Map.put(&1, :date, ~D[2019-12-20]))

    entries =
      server
      |> Todo.Server.entries(~D[2019-12-20])
      |> Enum.map(& &1.title)

    assert entries == ["Dentist"]
  end

  test "Deleting an entry", %{server: server} do
    Todo.Server.delete_entry(server, 1)

    entries =
      server
      |> Todo.Server.entries(~D[2018-12-19])
      |> Enum.map(& &1.title)

    assert entries == ["Movies"]
  end
end
