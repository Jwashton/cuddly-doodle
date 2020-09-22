defmodule Todo.DatabaseWorker do
  use GenServer

  def start_link({db_folder, worker_id}) do
    GenServer.start_link(__MODULE__, db_folder, name: via_tuple(worker_id))
  end

  def store(worker, key, data) do
    GenServer.cast(via_tuple(worker), {:store, key, data})
  end

  def get(worker, key) do
    GenServer.call(via_tuple(worker), {:get, key})
  end

  @impl GenServer
  def init(db_folder) do
    {:ok, db_folder}
  end

  @impl GenServer
  def handle_call({:get, key}, _, db_folder) do
    data =
      case File.read(file_name(db_folder, key)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

    {:reply, data, db_folder}
  end

  @impl GenServer
  def handle_cast({:store, key, data}, db_folder) do
    file = file_name(db_folder, key)

    File.write!(file, :erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  defp file_name(folder, key) do
    Path.join(folder, to_string(key))
  end

  defp via_tuple(worker_id) do
    Todo.ProcessRegistry.via_tuple({__MODULE__, worker_id})
  end
end
