defmodule Todo do
  alias Todo.{Cache, Server}

  def add_entry(list, entry) do
    list
    |> Cache.server_process()
    |> Server.add_entry(entry)
  end

  def entries(list, date) do
    list
    |> Cache.server_process()
    |> Server.entries(date)
  end
end
