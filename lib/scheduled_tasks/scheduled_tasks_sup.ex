defmodule ScheduledTasks.ScheduleSup do
  use Supervisor

  def start_link(init_state \\ []) do
    Supervisor.start_link(__MODULE__, init_state, name: __MODULE__)
  end

  @impl true
  def init(_start_numbers) do
    children = [Supervisor.child_spec({ScheduledTasks.Schedule, []}, id: 0)]

      IO.inspect(children)
    Supervisor.init(children, strategy: :one_for_one)
  end
end
