defmodule NflRushing.RushingStats do
  @moduledoc """
  context responsible for processing players rushing stats
  """

  alias NflRushing.Helpers.FileReader
  alias NflRushing.Schemas.PlayerRushingStats

  @spec get_rushing_stats :: list(PlayerRushingStats.t())
  def get_rushing_stats do
    FileReader.read_file() |> format_players_stats()
  end

  defp format_players_stats({:ok, players}) do
    Enum.map(players, &PlayerRushingStats.new/1)
  end
end
