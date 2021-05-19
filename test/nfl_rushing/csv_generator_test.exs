defmodule NflRushing.CSVGeneratorTest do
  @moduledoc false
  alias NflRushing.CSVGenerator

  use ExUnit.Case
  import Mock

  @json ~s([
    {
      "Player":"Charlie Whitehurst",
      "Team":"CLE",
      "Pos":"QB",
      "Att":2,
      "Att/G":2,
      "Yds":2,
      "Avg":0.5,
      "Yds/G":1,
      "TD":3,
      "Lng": 2,
      "1st":0,
      "1st%":0,
      "20+":0,
      "40+":0,
      "FUM":0
    },
    {
      "Player":"Jordan Howard",
      "Team":"CHI",
      "Pos":"RB",
      "Att":252,
      "Att/G":16.8,
      "Yds":"1,313",
      "Avg":5.2,
      "Yds/G":87.5,
      "TD":6,
      "Lng":"10",
      "1st":70,
      "1st%":27.8,
      "20+":10,
      "40+":2,
      "FUM":1
    },
    {
      "Player":"Lance Dunbar",
      "Team":"DAL",
      "Pos":"RB",
      "Att":9,
      "Att/G":0.7,
      "Yds":31,
      "Avg":3.4,
      "Yds/G":2.4,
      "TD":1,
      "Lng":"69",
      "1st":3,
      "1st%":33.3,
      "20+":0,
      "40+":0,
      "FUM":0
    }
  ])

  @charlie_line "Charlie Whitehurst, CLE, QB, 2, 2, 2, 0.5, 1, 3, 2, 0, 0, 0, 0, 0"
  @jordan_line "Jordan Howard, CHI, RB, 16.8, 252,\" 1,313\", 5.2, 87.5, 6, 10, 70, 27.8, 10, 2, 1"
  @lance_line "Lance Dunbar, DAL, RB, 0.7, 9, 31, 3.4, 2.4, 1, 69, 3, 33.3, 0, 0, 0"

  setup_with_mocks([
    {File, [], [read: fn _file_name -> {:ok, @json} end]}
  ]) do
    :ok
  end

  describe "generating csv" do
    test "format the right headers for the fields" do
      headers =
        "#, Player, Team, Pos, Att/G, Att, Yds, Avg, Yds/G, TD, Lng, 1st, 1st%, 20+, 40+, FUM"

      csv_content = CSVGenerator.generate(nil, "")

      assert csv_content =~ headers
      assert csv_content =~ @charlie_line
      assert csv_content =~ @jordan_line
      assert csv_content =~ @lance_line
    end

    test "puts only the filtered subset in the csv" do
      csv_content = CSVGenerator.generate(nil, "Jordan")

      refute csv_content =~ @charlie_line
      assert csv_content =~ @jordan_line
      refute csv_content =~ @lance_line
    end

    test "sort csv content" do
      csv_content = CSVGenerator.generate("asc_yds", "")

      assert csv_content =~ "#{1}, #{@charlie_line}"
      assert csv_content =~ "#{2}, #{@lance_line}"
      assert csv_content =~ "#{3}, #{@jordan_line}"
    end
  end
end
