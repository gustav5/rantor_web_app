defmodule ScrapeStore.Store do


  def store(data) do
    connect_to_database()
    |> create_table()
    |> insert_data(data)
  end

  def connect_to_database() do
    {:ok, db} = :raw_sqlite3.open("database1.db")
    db
  end

  def create_table(db) do
    :raw_sqlite3.exec(db, "CREATE TABLE IF NOT EXISTS rantor_2 (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, name TEXT, date TEXT, ranta DECIMAL(3,3), UNIQUE(name, date, ranta));")
    db
  end

  def insert_data(db, data) do
    data
    |> Enum.map(fn %{name: name, date: date, ranta: ranta} ->
      :raw_sqlite3.exec(db, "INSERT or ignore INTO rantor_2(name, date, ranta) VALUES('#{name}', '#{date}', #{ranta});")
    end)
  end

  def migrate_data(db) do
    :raw_sqlite3.q(db, "SELECT * FROM rantor")
    |> Enum.map(fn {_id, _mongo_id, name, date, ranta} ->
      #IO.inspect("INSERT or ignore INTO rantor_2(name, date, ranta) VALUES('#{name}', '#{String.replace(date, ~r"\T.*$"}', #{ranta});"
      :raw_sqlite3.exec(db, "INSERT or ignore INTO rantor_2(name, date, ranta) VALUES('#{name}', '#{String.replace(date, ~r"\T.*$","")}', #{ranta});")
    end)
  end
end
