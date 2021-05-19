defmodule NflRushing.RushingStatsTest do
  @moduledoc false
  use ExUnit.Case
  import Mock

  alias NflRushing.RushingStats
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
      "Lng":"2",
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

  setup_with_mocks([
    {File, [], [read: fn _file_name -> {:ok, @json} end]}
  ]) do
    :ok
  end

  describe "get rushing stats without sort" do
    test "returns the players rushing stats as read from json" do
      assert %RushingStats{
               all_stats: [
                 %{player: "Charlie Whitehurst"},
                 %{player: "Jordan Howard"},
                 %{player: "Lance Dunbar"}
               ]
             } = RushingStats.get_rushing_stats(1, nil)
    end
  end

  describe "get rushing stats sorted by total yards" do
    test "returns the players with least total yards first with asc_yds" do
      assert %RushingStats{
               all_stats: [
                 %{player: "Charlie Whitehurst"},
                 %{player: "Lance Dunbar"},
                 %{player: "Jordan Howard"}
               ]
             } = RushingStats.get_rushing_stats(1, "asc_yds")
    end

    test "returns the players with most total yards first with desc_yds" do
      assert %RushingStats{
               all_stats: [
                 %{player: "Jordan Howard"},
                 %{player: "Lance Dunbar"},
                 %{player: "Charlie Whitehurst"}
               ]
             } = RushingStats.get_rushing_stats(1, "desc_yds")
    end
  end

  describe "get rushing stats sorted by total rushing touchdowns" do
    test "returns the players with most total rushing touchdowns first with asc_td" do
      assert %RushingStats{
               all_stats: [
                 %{player: "Lance Dunbar"},
                 %{player: "Charlie Whitehurst"},
                 %{player: "Jordan Howard"}
               ]
             } = RushingStats.get_rushing_stats(1, "asc_td")
    end

    test "returns the players with least total rushing touchdowns first with desc_td" do
      assert %RushingStats{
               all_stats: [
                 %{player: "Jordan Howard"},
                 %{player: "Charlie Whitehurst"},
                 %{player: "Lance Dunbar"}
               ]
             } = RushingStats.get_rushing_stats(1, "desc_td")
    end
  end

  describe "get rushing stats sorted by longest rush" do
    test "returns the players with most longest rush first with asc_lng" do
      assert %RushingStats{
               all_stats: [
                 %{player: "Charlie Whitehurst"},
                 %{player: "Jordan Howard"},
                 %{player: "Lance Dunbar"}
               ]
             } = RushingStats.get_rushing_stats(1, "asc_lng")
    end

    test "returns the players with least longest rush first with desc_lng" do
      assert %RushingStats{
               all_stats: [
                 %{player: "Lance Dunbar"},
                 %{player: "Jordan Howard"},
                 %{player: "Charlie Whitehurst"}
               ]
             } = RushingStats.get_rushing_stats(1, "desc_lng")
    end
  end

  describe "get rushing stats with pagination" do
    @long_json ~s([
      {
        "Player":"Joe Banyard",
        "Team":"JAX",
        "Pos":"RB",
        "Att":2,
        "Att/G":2,
        "Yds":7,
        "Avg":3.5,
        "Yds/G":7,
        "TD":0,
        "Lng":"7",
        "1st":0,
        "1st%":0,
        "20+":0,
        "40+":0,
        "FUM":0
      },
      {
        "Player":"Shaun Hill",
        "Team":"MIN",
        "Pos":"QB",
        "Att":5,
        "Att/G":1.7,
        "Yds":5,
        "Avg":1,
        "Yds/G":1.7,
        "TD":0,
        "Lng":"9",
        "1st":0,
        "1st%":0,
        "20+":0,
        "40+":0,
        "FUM":0
      },
      {
        "Player":"Breshad Perriman",
        "Team":"BAL",
        "Pos":"WR",
        "Att":1,
        "Att/G":0.1,
        "Yds":2,
        "Avg":2,
        "Yds/G":0.1,
        "TD":0,
        "Lng":"2",
        "1st":0,
        "1st%":0,
        "20+":0,
        "40+":0,
        "FUM":0
      },
      {
        "Player":"Charlie Whitehurst",
        "Team":"CLE",
        "Pos":"QB",
        "Att":2,
        "Att/G":2,
        "Yds":1,
        "Avg":0.5,
        "Yds/G":1,
        "TD":0,
        "Lng":"2",
        "1st":0,
        "1st%":0,
        "20+":0,
        "40+":0,
        "FUM":0
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
        "Lng":"10",
        "1st":3,
        "1st%":33.3,
        "20+":0,
        "40+":0,
        "FUM":0
      },
      {
        "Player":"Mark Ingram",
        "Team":"NO",
        "Pos":"RB",
        "Att":205,
        "Att/G":12.8,
        "Yds":"1,043",
        "Avg":5.1,
        "Yds/G":65.2,
        "TD":6,
        "Lng":"75T",
        "1st":49,
        "1st%":23.9,
        "20+":4,
        "40+":2,
        "FUM":2
      },
      {
        "Player":"Reggie Bush",
        "Team":"BUF",
        "Pos":"RB",
        "Att":12,
        "Att/G":0.9,
        "Yds":-3,
        "Avg":-0.3,
        "Yds/G":-0.2,
        "TD":1,
        "Lng":5,
        "1st":2,
        "1st%":16.7,
        "20+":0,
        "40+":0,
        "FUM":1
      },
      {
        "Player":"Lucky Whitehead",
        "Team":"DAL",
        "Pos":"WR",
        "Att":10,
        "Att/G":0.7,
        "Yds":82,
        "Avg":8.2,
        "Yds/G":5.5,
        "TD":0,
        "Lng":"26",
        "1st":4,
        "1st%":40,
        "20+":1,
        "40+":0,
        "FUM":1
      },
      {
        "Player":"Brett Hundley",
        "Team":"GB",
        "Pos":"QB",
        "Att":3,
        "Att/G":0.8,
        "Yds":-2,
        "Avg":-0.7,
        "Yds/G":-0.5,
        "TD":0,
        "Lng":0,
        "1st":0,
        "1st%":0,
        "20+":0,
        "40+":0,
        "FUM":1
      },
      {
        "Player":"Tyreek Hill",
        "Team":"KC",
        "Pos":"WR",
        "Att":24,
        "Att/G":1.5,
        "Yds":267,
        "Avg":11.1,
        "Yds/G":16.7,
        "TD":3,
        "Lng":"70T",
        "1st":10,
        "1st%":41.7,
        "20+":4,
        "40+":2,
        "FUM":0
      },
      {
        "Player":"Randall Cobb",
        "Team":"GB",
        "Pos":"WR",
        "Att":10,
        "Att/G":0.8,
        "Yds":33,
        "Avg":3.3,
        "Yds/G":2.5,
        "TD":0,
        "Lng":"14",
        "1st":4,
        "1st%":40,
        "20+":0,
        "40+":0,
        "FUM":0
      },
      {
        "Player":"Aaron Ripkowski",
        "Team":"GB",
        "Pos":"FB",
        "Att":34,
        "Att/G":2.1,
        "Yds":150,
        "Avg":4.4,
        "Yds/G":9.4,
        "TD":2,
        "Lng":"15",
        "1st":10,
        "1st%":29.4,
        "20+":0,
        "40+":0,
        "FUM":0
      },
      {
        "Player":"Chris Moore",
        "Team":"BAL",
        "Pos":"WR",
        "Att":3,
        "Att/G":0.2,
        "Yds":19,
        "Avg":6.3,
        "Yds/G":1.3,
        "TD":0,
        "Lng":"10",
        "1st":1,
        "1st%":33.3,
        "20+":0,
        "40+":0,
        "FUM":0
      },
      {
        "Player":"Jeremy Hill",
        "Team":"CIN",
        "Pos":"RB",
        "Att":222,
        "Att/G":14.8,
        "Yds":"839",
        "Avg":3.8,
        "Yds/G":55.9,
        "TD":9,
        "Lng":"74T",
        "1st":42,
        "1st%":18.9,
        "20+":5,
        "40+":3,
        "FUM":0
      },
      {
        "Player":"Kenneth Farrow",
        "Team":"SD",
        "Pos":"RB",
        "Att":60,
        "Att/G":4.6,
        "Yds":192,
        "Avg":3.2,
        "Yds/G":14.8,
        "TD":0,
        "Lng":"11",
        "1st":10,
        "1st%":16.7,
        "20+":0,
        "40+":0,
        "FUM":1
      },
      {
        "Player":"Brandon Tate",
        "Team":"BUF",
        "Pos":"WR",
        "Att":3,
        "Att/G":0.2,
        "Yds":48,
        "Avg":16,
        "Yds/G":3.2,
        "TD":0,
        "Lng":"30",
        "1st":2,
        "1st%":66.7,
        "20+":1,
        "40+":0,
        "FUM":0
      }
    ])
    setup_with_mocks([
      {File, [], [read: fn _file_name -> {:ok, @long_json} end]}
    ]) do
      :ok
    end

    test "paginate the rushing stats" do
      assert %RushingStats{
               all_stats: all_stats,
               paginated_rushing_stats: paginated_rushing_stats,
               pagination: %{
                 page_number: 1,
                 total_entries: 16,
                 total_pages: 2
               }
             } = RushingStats.get_rushing_stats(1, nil)

      assert Enum.count(all_stats) == 16
      assert Enum.count(paginated_rushing_stats) == 15
    end

    test "returns the state by page number" do
      assert %RushingStats{
               all_stats: all_stats,
               paginated_rushing_stats: paginated_rushing_stats,
               pagination: %{
                 page_number: 2,
                 total_entries: 16,
                 total_pages: 2
               }
             } = RushingStats.get_rushing_stats(2, nil)

      assert Enum.count(all_stats) == 16
      assert Enum.count(paginated_rushing_stats) == 1
    end

    test "does the sort before pagination" do
      assert %RushingStats{
               paginated_rushing_stats: [%{total_yards: "839", player: "Jeremy Hill"} | _rest]
             } = RushingStats.get_rushing_stats(1, "desc_yds")
    end
  end
end
