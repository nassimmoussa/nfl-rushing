defmodule NflRushingWeb.StatsLiveTest do
  use NflRushingWeb.ConnCase

  import Mock

  @json ~s([
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
      "Lng":"69",
      "1st":70,
      "1st%":27.8,
      "20+":10,
      "40+":2,
      "FUM":1
    }
  ])

  import Phoenix.LiveViewTest

  setup_with_mocks([
    {File, [], [read: fn _file_name -> {:ok, @json} end]}
  ]) do
    :ok
  end

  test "render a table with players stats", %{conn: conn} do
    {:ok, _conn, html} = live(conn, "/")

    assert html =~
             "<thead><tr><th>Player</th><th>Team</th><th>Position</th><th>Game Attempts Avg</th><th>Total Attempts</th>"

    assert html =~
             "<th>Total Rushing Yards</th><th>Attempt avg yards</th><th>Total Rushing Touchdowns</th><th>Longest Rush</th>"

    assert html =~
             "<th>game avg yards</th><th>rushing first downs</th><th>rushing first downs percentage</th>"

    assert html =~
             "<th>rushing 20 plus</th><th>rushing 40 plus</th><th>rushing fumbles</th></tr></thead"

    assert html =~
             "<tr><td> Jordan Howard </td><td> CHI </td><td> RB </td><td> 16.8 </td><td> 252 </td><td> 1,313 </td><td> 5.2 </td><td> 6 </td><td> 69 </td><td> 87.5 </td><td> 70 </td><td> 27.8 </td><td> 10 </td><td> 2 </td><td> 1 </td></tr>"
  end
end
