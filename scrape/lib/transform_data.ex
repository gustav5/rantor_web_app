defmodule TransformData do

  def read_mongo do
    {:ok, conn} = Mongo.start_link(url: "mongodb://localhost:27017/rantor")
    cursor = Mongo.find(conn, "sparkonto_0ranta",%{})

    cursor
    |> Enum.to_list()
    |> IO.inspect
  end

  def transform(data) do
    filename = DateTime.to_iso8601(DateTime.utc_now())
    list =
      Enum.flat_map(data, fn %{"_id" => id, "name" => name, "ranta" => rantor} ->
        Enum.map(rantor, fn x ->
          date = List.first(Map.keys(x))
          %{id: inspect(id), name: name, date: date, ranta: inspect(Map.get(x,date))}
        end)
      end)

    File.write("data/#{filename}", Jason.encode!(list))
    # File.write("data/#{filename}", "[", [:append])

    # Enum.map(list, fn x -> File.write("data/#{filename}", inspect(x) <> ",", [:append]) end)

    # File.write("data/#{filename}", "]", [:append])
  end
end
