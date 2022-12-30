defmodule ScrapeStore.Manager do

  use GenServer

  # Client

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default, name: ScrapeStoreManager)
  end

  def work() do
    GenServer.call(__MODULE__, :work)
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    schedule_work(state)
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    scrape_store(state)
    {:ok, state} = schedule_work(state)
    {:noreply, state}
  end

  def schedule_work(state) do
    {:ok, millisecs} = ms_to_next_instance()
    IO.inspect("next scrape and store in : #{inspect(millisecs /1000)} seconds")
    Process.send_after(ScrapeStoreManager, :work, millisecs) |> IO.inspect()
    {:ok, state}
  end

  defp scrape_store(state) do
    case ScrapeStore.Scrape.scrape() do
      {:ok, data} ->
        ScrapeStore.Store.store(data)
        IO.inspect("done!")

      error ->
        IO.inspect(inspect(error))
    end
  end

  def ms_to_next_instance() do
    time_of_day = "09:02:20"
    with {:ok, backup_time} <- Time.from_iso8601(time_of_day),
         {:ok, time_diff} <- get_time_diff(backup_time) do
      if time_diff >= 0 do
        {:ok, time_diff}
      else
        {:ok, 86_400 * 1_000 + time_diff}
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_time_diff(backup_time) do
    {:ok, Time.diff(backup_time, Time.utc_now(), :millisecond)}
  end
end
