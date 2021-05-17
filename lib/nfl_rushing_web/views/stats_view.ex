defmodule NflRushingWeb.StatsView do
  use NflRushingWeb, :view

  @spec pagination_numbers(integer(), integer()) :: list()
  def pagination_numbers(current_page, total_pages) do
    initial_number = calc_initial_page_number(current_page, total_pages)
    last_number = calc_last_page_number(current_page, total_pages)

    Enum.to_list(initial_number..last_number)
  end

  defp calc_initial_page_number(current_page, _total_pages) when current_page <= 3, do: 1

  defp calc_initial_page_number(current_page, _total_pages), do: current_page - 3

  defp calc_last_page_number(current_page, total_pages) when current_page == total_pages,
    do: total_pages

  defp calc_last_page_number(current_page, total_pages) when total_pages - current_page <= 3,
    do: total_pages

  defp calc_last_page_number(current_page, _total_pages), do: current_page + 3
end
