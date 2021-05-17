defmodule NflRushing.RushingStats do
  @moduledoc """
  context responsible for processing players rushing stats
  """

  @page_size 15

  alias NflRushing.Helpers.FileReader
  alias NflRushing.Schemas.PlayerRushingStats

  @spec get_rushing_stats(integer) :: %{
          pagination: %{
            page_number: integer(),
            total_entries: non_neg_integer(),
            total_pages: integer()
          },
          rushing_stats: list(PlayerRushingStats.t())
        }
  def get_rushing_stats(page) do
    FileReader.read_file()
    |> format_players_stats()
    |> add_pagination(page)
  end

  defp format_players_stats({:ok, players}) do
    Enum.map(players, &PlayerRushingStats.new/1)
  end

  defp add_pagination(stats, page) do
    total_pages = ceil(length(stats) / @page_size)
    {rushing_stats, _rest} = stats |> Enum.chunk_every(@page_size) |> List.pop_at(page - 1)

    %{
      rushing_stats: rushing_stats,
      pagination: %{
        page_number: page,
        total_entries: length(stats),
        total_pages: total_pages
      }
    }
  end
end
