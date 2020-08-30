defmodule Todo.DatabaseTest do
  use ExUnit.Case
  alias Todo.Database

  setup do
    # Two problems
    #
    # 1. This tries to start the Database process for each test. Can we use
    #    `start_supervised(Database)` ?
    # 2. Database.clear() removes the ./persist directory, so that folder doesn't
    #    exist for the second test.
    #    Maybe File.rm_rf!(Path.join(@db_folder, "*"))?
    # start_supervised!(Database, start: {Database, :start, []})
    Database.start()

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
