defmodule Todo.Server do
  use GenServer

  def start(database, list_name) do
    GenServer.start(__MODULE__, {database, list_name})
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
  def init({database, name}) do
    {:ok, nil, {:continue, {database, name}}}
  end

  @impl GenServer
  def handle_continue({database, name}, _) do
    {:noreply, {database, name, database.get(name) || Todo.List.new()}}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {database, name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    database.store(name, new_list)
    {:noreply, {database, name, new_list}}
  end

  @impl GenServer
  def handle_cast({:delete_entry, entry_id}, {database, name, todo_list}) do
    new_list = Todo.List.delete_entry(todo_list, entry_id)
    database.store(name, new_list)
    {:noreply, {database, name, new_list}}
  end

  @impl GenServer
  def handle_cast({:update_entry, entry_id, entry_updater}, {database, name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, entry_id, entry_updater)
    database.store(name, new_list)
    {:noreply, {database, name, new_list}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _from, {database, name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), {database, name, todo_list}}
  end
end
