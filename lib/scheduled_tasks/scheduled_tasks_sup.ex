defmodule ScheduledTasks.ScheduleSup do
  use Supervisor

  def start_link(init_state \\ []) do
    Supervisor.start_link(__MODULE__, init_state, name: __MODULE__)
  end

  @impl true
  def init(start_numbers) do
    children = []
    Supervisor.init(children, strategy: :one_for_one)
  end
end
