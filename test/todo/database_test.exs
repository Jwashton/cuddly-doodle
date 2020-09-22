defmodule Todo.DatabaseTest do
  use ExUnit.Case
  alias Todo.Database

  setup do
    start_supervised!(Todo.ProcessRegistry)
    start_supervised!(Database)

    on_exit(fn ->
      Database.clear()
    end)
  end

  test "starting empty" do
    assert Database.get(:red) == nil
  end

  test "storing values" do
    Database.store(:red, {255, 0, 0})

    assert Database.get(:red) == {255, 0, 0}
  end
end
