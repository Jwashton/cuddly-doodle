defmodule Todo.DatabaseTest do
  use ExUnit.Case
  alias Todo.Database

  setup_all do
    Database.start()

    :ok
  end

  setup do
    # start_supervised!(Database, start: {Database, :start, []})

    on_exit fn ->
      Database.clear()
    end
  end

  test "starting empty" do
    assert Database.get(:red) == nil
  end

  test "storing values" do
    Database.store(:red, {255, 0, 0})

    assert Database.get(:red) == {255, 0, 0}
  end
end
