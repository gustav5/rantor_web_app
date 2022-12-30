defmodule ScrapeStore.Scrape do


  def do_scrape() do
    date = Date.to_iso8601(Date.utc_today())
    file =
      "https://www.compricer.se/sparande/"
      |> HTTPoison.get!()
      |> Map.get(:body)
      |> Floki.parse_document!()
      |> Floki.find("vue-saving-interest-rate-table")
      |> List.first() #|> IO.inspect()
      |> elem(1) #|> IO.inspect(label: "at")
      |> Enum.at(1)
      |> elem(1)
      #|> elem(1)
      |> Jason.decode!()
      |> Enum.filter(fn x -> Map.has_key?(x, "Rates") end)
      |> Enum.map(fn x -> {Map.get(x, "ProviderName"), Map.get(x, "Rates")} end)
      |> Enum.map(fn {name, rates} ->
          {name, List.first(Enum.filter(rates, fn rate -> Map.get(rate, "BindTime") == "0months" end))}
      end )
      |> Enum.map(fn {name, rates} ->
        case is_map(rates) do
          true -> {name, Map.get(rates, "MaxRate")}
          false -> {name, rates}
        end
      end)
      |> Enum.filter(fn {_name, rate} -> rate != nil end)
      |> Enum.sort_by(fn {_name, rate} -> rate end, :desc)
      |> Enum.map(fn {name, ranta} -> %{date: date, name: name, ranta: ranta} end)
    file
  end

  # def write_to_file(data) do
  #   filename = DateTime.to_iso8601(DateTime.utc_now())
  #   File.write!("sql_data/" <> filename, Jason.encode!(data))
  #   File.write!("sql_data/latest", filename)
  # end

  def scrape do
    data = do_scrape()
    {:ok, data}
  end
end
