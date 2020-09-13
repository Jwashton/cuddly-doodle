defmodule Todo.Database do
  use GenServer
  alias Todo.DatabaseWorker

  @db_folder "./persist"

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def clear() do
    File.rm_rf!(@db_folder)
    File.mkdir_p!(@db_folder)
  end

  def store(key, data) do
    worker = choose_worker(key)
    DatabaseWorker.store(worker, key, data)
  end

  def get(key) do
    worker = choose_worker(key)
    DatabaseWorker.get(worker, key)
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)

    workers =
      for n <- 0..2, into: %{} do
        {:ok, worker} = DatabaseWorker.start_link(@db_folder)

        {n, worker}
      end

    {:ok, workers}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _, workers) do
    {:reply, workers[:erlang.phash2(key, 3)], workers}
  end

  @impl GenServer
  def terminate(_reason, workers) do
    Enum.each(workers, fn {_n, worker} -> GenServer.stop(worker) end)
  end
end
