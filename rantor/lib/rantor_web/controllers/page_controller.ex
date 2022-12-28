defmodule RantorWeb.PageController do
  use RantorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
