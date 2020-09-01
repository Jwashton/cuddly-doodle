defmodule Todo.Cache do
  use GenServer

  def start(database \\ Todo.Database) do
    GenServer.start(__MODULE__, database)
  end

  def server_process(cache_pid, todo_list_name) do
    GenServer.call(cache_pid, {:server_process, todo_list_name})
  end

  @impl GenServer
  def init(database) do
    # Is this going to fail if we have start multiple caches?
    database.start()
    {:ok, {database, %{}}}
  end

  @impl GenServer
  def handle_call({:server_process, todo_list_name}, _, {database, todo_servers}) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, {database, todo_servers}}

      :error ->
        {:ok, new_server} = Todo.Server.start(database, todo_list_name)
        new_servers = Map.put(todo_servers, todo_list_name, new_server)

        {:reply, new_server, {database, new_servers}}
    end
  end
end
