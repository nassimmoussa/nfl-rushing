defmodule NflRushing.Schemas.PlayerRushingStats do
  @moduledoc """
  schema representation of player rushing stats
  """

  @type t :: %__MODULE__{
          player: String.t(),
          team: String.t(),
          position: String.t(),
          longest_rush: String.t(),
          game_attempts_avg: number(),
          total_attempts: number(),
          total_yards: number(),
          attempt_avg_yards: number(),
          game_avg_yards: number(),
          total_rushing_touchdowns: number(),
          rushing_first_downs: number(),
          rushing_first_downs_percentage: number(),
          rushing_20_plus: number(),
          rushing_40_plus: number(),
          rushing_fumbles: number()
        }
  defstruct player: nil,
            team: nil,
            position: nil,
            game_attempts_avg: nil,
            total_attempts: nil,
            total_yards: nil,
            attempt_avg_yards: nil,
            game_avg_yards: nil,
            total_rushing_touchdowns: nil,
            longest_rush: nil,
            rushing_first_downs: nil,
            rushing_first_downs_percentage: nil,
            rushing_20_plus: nil,
            rushing_40_plus: nil,
            rushing_fumbles: nil

  @spec new(map) :: __MODULE__.t()
  def new(%{
        "Player" => player,
        "Team" => team,
        "Pos" => position,
        "Att/G" => game_attempts_avg,
        "Att" => total_attempts,
        "Yds" => total_yards,
        "Avg" => attempt_avg_yards,
        "Yds/G" => game_avg_yards,
        "TD" => total_rushing_touchdowns,
        "Lng" => longest_rush,
        "1st" => rushing_first_downs,
        "1st%" => rushing_first_downs_percentage,
        "20+" => rushing_20_plus,
        "40+" => rushing_40_plus,
        "FUM" => rushing_fumbles
      }) do
    %__MODULE__{
      player: player,
      team: team,
      position: position,
      game_attempts_avg: game_attempts_avg,
      total_attempts: total_attempts,
      total_yards: total_yards,
      attempt_avg_yards: attempt_avg_yards,
      game_avg_yards: game_avg_yards,
      total_rushing_touchdowns: total_rushing_touchdowns,
      longest_rush: longest_rush,
      rushing_first_downs: rushing_first_downs,
      rushing_first_downs_percentage: rushing_first_downs_percentage,
      rushing_20_plus: rushing_20_plus,
      rushing_40_plus: rushing_40_plus,
      rushing_fumbles: rushing_fumbles
    }
  end
end
