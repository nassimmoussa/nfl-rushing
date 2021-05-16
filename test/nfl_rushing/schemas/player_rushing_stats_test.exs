defmodule NflRushing.Schemas.PlayerRushingStatsTest do
  @moduledoc false
  use ExUnit.Case

  alias NflRushing.Schemas.PlayerRushingStats

  describe "new/1" do
    test "formats a strings map to player rushing schema" do
      strings_map = %{
        "Player" => "Joe Kerridge",
        "Team" => "GB",
        "Pos" => "RB",
        "Att" => 1,
        "Att/G" => 2,
        "Yds" => 3,
        "Avg" => 4,
        "Yds/G" => 5,
        "TD" => 6,
        "Lng" => "0",
        "1st" => 7,
        "1st%" => 8,
        "20+" => 9,
        "40+" => 10,
        "FUM" => 11
      }

      assert match?(
               %PlayerRushingStats{
                 player: "Joe Kerridge",
                 attempt_avg_yards: 4,
                 game_attempts_avg: 2,
                 game_avg_yards: 5,
                 longest_rush: "0",
                 position: "RB",
                 rushing_20_plus: 9,
                 rushing_40_plus: 10,
                 rushing_first_downs: 7,
                 rushing_first_downs_percentage: 8,
                 rushing_fumbles: 11,
                 team: "GB",
                 total_attempts: 1,
                 total_rushing_touchdowns: 6,
                 total_yards: 3
               },
               PlayerRushingStats.new(strings_map)
             )
    end
  end
end
