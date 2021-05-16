defmodule NflRushingWeb.PageLiveTest do
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
             "<thead><tr><th>Player</th><th>Team</th><th>Position</th><th>Rushing Attempts Per Game Average</th><th>Longest Rush</th></tr></thead>"

    assert html =~
             "<td> Jordan Howard </td><td> CHI </td><td> RB </td><td> 16.8 </td><td> 69 </td>"
  end
end
