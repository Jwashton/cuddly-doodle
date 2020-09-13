defmodule Todo.Cache do
  use GenServer

  def start_link(database \\ Todo.Database) do
    GenServer.start_link(__MODULE__, database, name: __MODULE__)
  end

  def server_process(todo_list_name) do
    GenServer.call(__MODULE__, {:server_process, todo_list_name})
  end

  def flush() do
    GenServer.call(__MODULE__, :flush)
  end

  def child_spec([]) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
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
        {:ok, new_server} = Todo.Server.start_link(database, todo_list_name)
        new_servers = Map.put(todo_servers, todo_list_name, new_server)

        {:reply, new_server, {database, new_servers}}
    end
  end

  def handle_call(:flush, _, {database, _todo_servers}) do
    {:reply, :ok, {database, %{}}}
  end
end
