defmodule ScheduledTasks.Schedule do
  use GenServer
  use Supervisor
  require Logger

  # CLIENT
  def start_link(start_from, opts \\ []) do
    IO.puts("Starting a Schedule")
    GenServer.start_link(__MODULE__, start_from, opts)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def cancel_time(pid) do
    GenServer.call(pid, :cancel_timer)
  end

  def init(start_from) do
    time_ref = Process.send_after(self(), :tick, start_from)
    {:ok, {time_ref, start_from}}
  end

  # SERVER
  def handle_call(:cancel_timer, _from, state) do
    elem(state, 0)
    |> (&(Process.cancel_timer(&1))).()
    {:reply, state, state}
  end

  def handle_call(:get, _from, st) do
    {:reply, st, st}
  end

  def handle_info(:tick, state) do
    time =
      DateTime.utc_now()
      |> DateTime.to_time()
      |> Time.to_iso8601()

    IO.puts("The time is now: #{time}")

    {:noreply, state}
  end

end
