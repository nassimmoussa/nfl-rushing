defmodule NflRushing.CSVGenerator do
  @moduledoc """
  context for generating CSV for rushing stats
  """
  alias NflRushing.RushingStats

  @spec generate(nil | String.t(), String.t()) :: binary()
  def generate(sort_by, player_filter) do
    RushingStats.get_rushing_stats(1, sort_by, player_filter)
    |> Map.fetch!(:all_stats)
    |> format_data()
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string
  end

  defp format_data(stats) do
    stats
    |> Stream.map(&serialize_player_stats/1)
    |> Stream.with_index(1)
    |> Enum.map(fn {row, index} ->
      [" #{index}" | row]
    end)
    |> prepend_headers()
  end

  defp serialize_player_stats(player_stats) do
    [
      " #{player_stats.player}",
      " #{player_stats.team}",
      " #{player_stats.position}",
      " #{player_stats.game_attempts_avg}",
      " #{player_stats.total_attempts}",
      " #{player_stats.total_yards}",
      " #{player_stats.attempt_avg_yards}",
      " #{player_stats.game_avg_yards}",
      " #{player_stats.total_rushing_touchdowns}",
      " #{player_stats.longest_rush}",
      " #{player_stats.rushing_first_downs}",
      " #{player_stats.rushing_first_downs_percentage}",
      " #{player_stats.rushing_20_plus}",
      " #{player_stats.rushing_40_plus}",
      " #{player_stats.rushing_fumbles}"
    ]
  end

  defp prepend_headers(list) do
    headers = [
      " #",
      " Player",
      " Team",
      " Pos",
      " Att/G",
      " Att",
      " Yds",
      " Avg",
      " Yds/G",
      " TD",
      " Lng",
      " 1st",
      " 1st%",
      " 20+",
      " 40+",
      " FUM"
    ]

    [headers | list]
  end
end
