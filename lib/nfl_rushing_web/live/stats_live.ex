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
    %{paginated_rushing_stats: rushing_stats, pagination: pagination, sort_by: sort_by} =
      RushingStats.get_rushing_stats(1, nil)

    {:ok, assign(socket, rushing_stats: rushing_stats, pagination: pagination, sort_by: sort_by)}
  end

  @impl true
  @spec handle_event(binary(), Phoenix.LiveView.unsigned_params(), Phoenix.LiveView.Socket.t()) ::
          {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_event("pagination", %{"page" => page}, socket) do
    {page_number, _} = Integer.parse(page)

    %{paginated_rushing_stats: rushing_stats, pagination: pagination, sort_by: sort_by} =
      RushingStats.get_rushing_stats(page_number, socket.assigns.sort_by)

    {:noreply,
     assign(socket, rushing_stats: rushing_stats, pagination: pagination, sort_by: sort_by)}
  end

  def handle_event("sort", %{"sort_by" => sort_by_param}, socket) do
    if sort_by_param == socket.assigns.sort_by do
      {:noreply, socket}
    else
      %{paginated_rushing_stats: rushing_stats, pagination: pagination, sort_by: sort_by} =
        RushingStats.get_rushing_stats(1, sort_by_param)

      {:noreply,
       assign(socket, rushing_stats: rushing_stats, pagination: pagination, sort_by: sort_by)}
    end
  end
end
