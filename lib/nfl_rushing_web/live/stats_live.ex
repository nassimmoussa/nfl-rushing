defmodule NflRushingWeb.StatsLive do
  use NflRushingWeb, :live_view

  alias NflRushing.RushingStats

  @impl true
  @spec render(Phoenix.LiveView.Socket.assigns()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    Phoenix.View.render(NflRushingWeb.StatsView, "index.html", assigns)
  end

  @impl true
  @spec mount(
          Phoenix.LiveView.unsigned_params() | :not_mounted_at_router,
          map(),
          Phoenix.LiveView.Socket.t()
        ) ::
          {:ok, Phoenix.LiveView.Socket.t()}
  def mount(_params, _session, socket) do
    %{rushing_stats: rushing_stats, pagination: pagination} = RushingStats.get_rushing_stats(1)

    {:ok,
     assign(socket,
       rushing_stats: rushing_stats,
       pagination: pagination
     )}
  end

  @impl true
  @spec handle_event(binary(), Phoenix.LiveView.unsigned_params(), Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_event("pagination", %{"page" => page}, socket) do
    {page_number, _} = Integer.parse(page)

    %{rushing_stats: rushing_stats, pagination: pagination} =
      RushingStats.get_rushing_stats(page_number)

    {:noreply,
     assign(socket,
       rushing_stats: rushing_stats,
       pagination: pagination
     )}
  end
end
