defmodule Todo.Server do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def add_entry(server, new_entry) do
    GenServer.cast(server, {:add_entry, new_entry})
  end

  def delete_entry(server, entry_id) do
    GenServer.cast(server, {:delete_entry, entry_id})
  end

  def update_entry(server, entry_id, entry_updater) do
    GenServer.cast(server, {:update_entry, entry_id, entry_updater})
  end

  def entries(server, date) do
    GenServer.call(server, {:entries, date})
  end

  @impl GenServer
  def init(_) do
    {:ok, Todo.List.new()}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, Todo.List.add_entry(todo_list, new_entry)}
  end

  @impl GenServer
  def handle_cast({:delete_entry, entry_id}, todo_list) do
    {:noreply, Todo.List.delete_entry(todo_list, entry_id)}
  end

  @impl GenServer
  def handle_cast({:update_entry, entry_id, entry_updater}, todo_list) do
    {:noreply, Todo.List.update_entry(todo_list, entry_id, entry_updater)}
  end

  @impl GenServer
  def handle_call({:entries, date}, _from, todo_list) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end
end
