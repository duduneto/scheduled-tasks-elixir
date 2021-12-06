defmodule ScheduledTasks.Manager do
  use Supervisor

  def create(value) do
    Supervisor.child_spec({ScheduledTasks.Schedule, value}, id: :os.system_time(:millisecond))
    |> (&Supervisor.start_child(ScheduledTasks.ScheduleSup, &1)).()
    |> is_active
  end

  def is_active({_, pid}) do
    Process.alive?(pid)
  end

  def list do
    Supervisor.which_children(ScheduledTasks.ScheduleSup)
  end

  def kill(pid) do
    # First cancel scheduled timer
    ScheduledTasks.Schedule.cancel_time(pid)
    # Terminate Children
    Supervisor.which_children(ScheduledTasks.ScheduleSup)
    |> Enum.find(fn
      # pinned self → it’s me!
      {id, pid, _, _} -> id
      # skip everything else
      _ -> nil
    end)
    |> (&terminate_process(elem(&1, 0))).()
  end

  def terminate_process(process_id) do
    Supervisor.terminate_child(ScheduledTasks.ScheduleSup, process_id)
    Supervisor.delete_child(ScheduledTasks.ScheduleSup, process_id)
  end
end
