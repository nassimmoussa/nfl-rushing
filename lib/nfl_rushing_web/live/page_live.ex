defmodule NflRushingWeb.PageLive do
  use NflRushingWeb, :live_view

  alias NflRushing.RushingStats

  @impl true
  def mount(_params, _session, socket) do
    rushing_stats = RushingStats.get_rushing_stats()

    {:ok, assign(socket, rushing_stats: rushing_stats)}
  end
end
