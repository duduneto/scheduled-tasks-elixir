defmodule ScheduledTasks.Schedule do
  use GenServer
  require Logger

  def start_link(start_from, opts \\ []) do
    IO.puts("Starting a Schedule")
    GenServer.start_link(__MODULE__, start_from, opts)
  end

  def get(pid) do
    GenServer.call(pid, :get)
  end

  def init(start_from) do
    Process.send_after(self(), :tick, start_from)

    {:ok, start_from}
  end

  def handle_call(:get, _from, st) do
    {:reply, st.current, st}
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
