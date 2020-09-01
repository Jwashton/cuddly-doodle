defmodule Todo.CacheTest do
  use ExUnit.Case
  
  setup do
    {:ok, cache} = Todo.Cache.start()
    
    on_exit(fn ->
      Todo.Database.clear()
      GenServer.stop(Todo.Database)
    end)
    
    %{cache: cache}
  end

  test "general usage", %{cache: cache} do
    bob_pid = Todo.Cache.server_process(cache, "Bob's list")
    assert is_pid(bob_pid)

    assert Todo.Cache.server_process(cache, "Bob's list") == bob_pid
    assert Todo.Cache.server_process(cache, "Alice's list") != bob_pid
  end

  test "to-do operations", %{cache: cache} do
    alice = Todo.Cache.server_process(cache, "alice")
    Todo.Server.add_entry(alice, %{date: ~D[2018-12-19], title: "Dentist"})
    entries = Todo.Server.entries(alice, ~D[2018-12-19])

    assert [%{date: ~D[2018-12-19], title: "Dentist"}] = entries
  end
end
