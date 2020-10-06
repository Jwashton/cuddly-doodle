defmodule Todo.System do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, nil)
  end

  defp children() do
    [
      Todo.ProcessRegistry,
      Todo.Database,
      Todo.Cache,
      Todo.Web
    ]
  end

  @impl Supervisor
  def init(_) do
    Supervisor.init(children(), strategy: :one_for_one)
  end
end
