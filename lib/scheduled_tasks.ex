defmodule ScheduledTasks.Schedule do
  use GenServer

  # CLIENT
  def start_link(init_state \\ []) do
    GenServer.start_link(__MODULE__, init_state, name: __MODULE__)
  end

  def add(event) do
    GenServer.cast(__MODULE__, {:add, event})
  end

  def show do
    GenServer.call(__MODULE__, {:view})
  end

  def remove_last do
    GenServer.cast(__MODULE__, :remove)
  end

  # SERVER

  def handle_cast(:remove, state) do
    [removed_item | updated_list] = state
    handle_remove_event(removed_item)
    {:noreply, state}
  end

  def handle_cast({:add, new_event}, state) do
    {:ok, ref} = handle_add_event(new_event)
    updated_list = [ref | state]
    {:noreply, updated_list}
  end

  def handle_call({:view}, _from, state) do
    {:reply, state, state}
  end

  def handle_remove_event({_, ref}) do
    Process.cancel_timer(ref)
    {:ok, {ref}}
  end

  def handle_add_event(time_schedule) do
    {:ok, {:interval, ref}} = :timer.send_interval(time_schedule, :dispatch_new_scheduled_task)
    {:ok, {time_schedule, ref}}
  end

  def handle_info(:dispatch_new_scheduled_task, state) do
    # state is list of tuples. with the first index the recently added schedule time
    List.first(state)
    |> dispatch_scheduled_task
    {:noreply, state}
  end

  defp dispatch_scheduled_task(state) do
    # state is and tuple. with the first parameter the time in ms
    elem(state, 0)
    |> (&(IO.puts("Dispatched at #{Integer.to_string(&1)}"))).()
  end

end
