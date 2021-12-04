defmodule ScheduledTasks.Manager do
  use Supervisor

  def create(value) do
    Supervisor.child_spec({ScheduledTasks.Schedule, value}, id: :os.system_time(:millisecond))
    |> (&(Supervisor.start_child(ScheduledTasks.ScheduleSup, &1))).()
    |> is_active
  end

  def is_active({_, pid}) do
    Process.alive? (pid)
  end

  def list do
    Supervisor.which_children(ScheduledTasks.ScheduleSup)
  end

end
