defmodule ScheduledTasks.ScheduleSup do
  use Supervisor

  def start_link(init_state \\ []) do
    Supervisor.start_link(__MODULE__, init_state, name: __MODULE__)
  end

  @impl true
  def init(start_numbers) do
    children =
      for start_number <- start_numbers do
        # We can't just use `{OurNewApp.Counter, start_number}`
        # because we need different ids for children

        Supervisor.child_spec({ScheduledTasks.Schedule, start_number}, id: start_number)
      end
      IO.inspect(children)
    Supervisor.init(children, strategy: :one_for_one)
  end
end
