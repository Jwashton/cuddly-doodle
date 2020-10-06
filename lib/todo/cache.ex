defmodule Todo.Cache do
  use DynamicSupervisor

  @name __MODULE__

  def start_link(database \\ Todo.Database, options \\ []) do
    with_defaults = Keyword.put_new(options, :name, @name)
    DynamicSupervisor.start_link(__MODULE__, database, with_defaults)
  end

  def server_process(sup_name \\ @name, todo_list_name) do
    case start_child(sup_name, todo_list_name) do
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

  defp start_child(name, todo_list_name) do
    DynamicSupervisor.start_child(
      name,
      {Todo.Server, todo_list_name}
    )
  end
end
