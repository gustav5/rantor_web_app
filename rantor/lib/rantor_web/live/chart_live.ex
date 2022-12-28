defmodule RantorWeb.ChartLive do
  use RantorWeb, :live_view

  def mount(_params, _session, socket) do
    # if connected?(socket) do
    #   :timer.send_interval(1000, self(), :update)
    # end

    {labels, data} = get_sql_data()

    {:ok,
     assign(socket,
       chart_data: %{
         labels: labels,
         values: data
       },
       current_reading: List.last(labels)
     )}
  end

  def render(assigns) do
    ~L"""
    <div id="charting">
      <div phx-update="ignore">
        <div style="position:absolute; top:20px; left:0px; width:1300px; height:500px;">
          <canvas id="chart-canvas"
                  phx-hook="LineChart"
                  data-chart-data="<%= Jason.encode!(@chart_data) %>">
          </canvas>
        </div>
      </div>
    </div>
    """
  end

  def handle_info(:update, socket) do
    {:noreply, add_point(socket)}
  end

  def handle_event("get-reading", _, socket) do
    {:noreply, add_point(socket)}
  end

  defp add_point(socket) do
    socket = update(socket, :current_reading, &(&1 + 1))

    point = %{
      label: socket.assigns.current_reading,
      value: get_reading()
    }

    push_event(socket, "new-point", point)
  end

  defp get_reading do
    Enum.random(70..180)
  end

  def get_sql_data() do
    {:ok, db} = :raw_sqlite3.open("../database_sqlite/database1.db")

    data =
      db
      |> :raw_sqlite3.q("SELECT name, date, ranta FROM rantor")
      |> Enum.map(fn {name, date_time, ranta} -> {name, String.replace(date_time, ~r"\T.*$",""),ranta} end)
      |> Enum.group_by(fn {name, _date_time, _ranta} -> name end)
      |> Enum.map(fn {name,x} ->
        {name, Enum.map(x, fn {_name, date_time, ranta} -> {date_time, ranta} end)}
      end)
    :raw_sqlite3.close(db)

    labels =
      data
      |> List.first()
      |> elem(1)
      |> Enum.map(fn {date, _rantor} -> date end)

    data =
      data
      |> Enum.map(fn {name,x} ->
          %{name => Enum.map(x, fn {_date_time, ranta} -> ranta end)}
        end)
    {labels, data}
  end
end
