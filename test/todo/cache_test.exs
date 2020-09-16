defmodule Todo.CacheTest do
  use ExUnit.Case

  defmodule MockDatabase do
    def start_link(_), do: nil
    def store(_key, _data), do: nil
    def get(_key), do: nil
  end

  setup_all do
    {:ok, _} = Todo.Cache.start_link(MockDatabase)

    :ok
  end

  test "general usage" do
    bob_pid = Todo.Cache.server_process("Bob's list")
    assert is_pid(bob_pid)

    assert Todo.Cache.server_process("Bob's list") == bob_pid
    assert Todo.Cache.server_process("Alice's list") != bob_pid
  end

  test "to-do operations" do
    alice = Todo.Cache.server_process("alice")
    Todo.Server.add_entry(alice, %{date: ~D[2018-12-19], title: "Dentist"})
    entries = Todo.Server.entries(alice, ~D[2018-12-19])

    assert [%{date: ~D[2018-12-19], title: "Dentist"}] = entries
  end
end
