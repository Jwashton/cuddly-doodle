defmodule Todo.CacheTest do
  use ExUnit.Case

  test "general usage" do
    {:ok, cache} = Todo.Cache.start()

    bob_pid = Todo.Cache.server_process(cache, "Bob's list")
    assert is_pid(bob_pid)

    assert Todo.Cache.server_process(cache, "Bob's list") == bob_pid
    assert Todo.Cache.server_process(cache, "Alice's list") != bob_pid
  end

  test "to-do operations" do
    {:ok, cache} = Todo.Cache.start()

    alice = Todo.Cache.server_process(cache, "alice")
    Todo.Server.add_entry(alice, %{date: ~D[2018-12-19], title: "Dentist"})
    entries = Todo.Server.entries(alice, ~D[2018-12-19])

    assert [%{date: ~D[2018-12-19], title: "Dentist"}] = entries
  end
end
