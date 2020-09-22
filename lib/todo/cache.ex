defmodule Todo.Cache do
  use DynamicSupervisor

  def start_link(database \\ Todo.Database) do
    DynamicSupervisor.start_link(__MODULE__, database, name: __MODULE__)
  end

  def server_process(todo_list_name) do
    case start_child(todo_list_name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, List.wrap(args)},
      type: :supervisor
    }
  end

  @impl DynamicSupervisor
  def init(database) do
    DynamicSupervisor.init(strategy: :one_for_one, extra_arguments: [database])
  end

  defp start_child(todo_list_name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {Todo.Server, todo_list_name}
    )
  end
end
