defmodule Scrape do
  @moduledoc """
  Documentation for `Scrape`.
  """


  def scrape(url) do
    file =
      url
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
      |> Enum.map(fn {name, ranta} -> %{name: name, ranta: ranta} end)

    file
  end

  def put_data_in_mongo(data, url) do
    {:ok, conn} = Mongo.start_link(url: url)
    datetime = DateTime.to_iso8601(DateTime.truncate(DateTime.utc_now, :second))

    Enum.map(data, fn x ->
      Mongo.update_one!(conn, "sparkonto_0ranta",%{name: Map.get(x, :name)},  %{"$push": %{ranta: %{datetime => Map.get(x, :ranta)/1}}})
    end)
  end

  def do_scrape_and_store_in_mongodb do
    scrape("https://www.compricer.se/sparande/")
    |> put_data_in_mongo("mongodb://localhost:27017/rantor")
  end
end
