defmodule Todo.CacheTest do
  use ExUnit.Case
  alias Todo.{Cache, Server}

  defmodule MockDatabase do
    def start_link(_), do: nil
    def store(_key, _data), do: nil
    def get(_key), do: nil
  end

  setup_all do
    start_supervised!({Cache, [MockDatabase, [name: :test_cache]]})

    :ok
  end

  test "general usage" do
    bob_pid = Cache.server_process(:test_cache, "Bob's list")
    assert is_pid(bob_pid)

    assert Cache.server_process(:test_cache, "Bob's list") == bob_pid
    assert Cache.server_process(:test_cache, "Alice's list") != bob_pid
  end

  test "to-do operations" do
    alice = Cache.server_process(:test_cache, "alice")
    Server.add_entry(alice, %{date: ~D[2018-12-19], title: "Dentist"})
    entries = Server.entries(alice, ~D[2018-12-19])

    assert [%{date: ~D[2018-12-19], title: "Dentist"}] = entries
  end
end
