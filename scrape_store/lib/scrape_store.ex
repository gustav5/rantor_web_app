defmodule ScrapeStore do

  def work do
    with  {:ok, data} <- ScrapeStore.Scrape.scrape(),
          :ok <- ScrapeStore.Store.store(data) do
            IO.inspect(data)
    else
      error -> error
    end
  end
end
