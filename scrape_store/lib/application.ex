defmodule ScrapeStore.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {ScrapeStore.Manager, []}
    ]

    opts = [strategy: :one_for_one, name: ScrapeStore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
