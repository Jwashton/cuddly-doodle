defmodule Todo.Server do
  use GenServer

  def start(list_name) do
    GenServer.start(__MODULE__, list_name)
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
  def init(name) do
    {:ok, nil, {:continue, name}}
  end

  @impl GenServer
  def handle_continue(name, _) do
    {:noreply, {name, Todo.Database.get(name) || Todo.List.new()}}
  end

  @impl GenServer
  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_list = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl GenServer
  def handle_cast({:delete_entry, entry_id}, {name, todo_list}) do
    new_list = Todo.List.delete_entry(todo_list, entry_id)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl GenServer
  def handle_cast({:update_entry, entry_id, entry_updater}, {name, todo_list}) do
    new_list = Todo.List.update_entry(todo_list, entry_id, entry_updater)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _from, {_name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end
end
