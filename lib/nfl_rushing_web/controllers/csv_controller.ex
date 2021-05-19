defmodule NflRushingWeb.CSVController do
  @moduledoc false
  use NflRushingWeb, :controller

  alias NflRushing.CSVGenerator

  @spec export(Plug.Conn.t(), map) :: Plug.Conn.t()
  def export(conn, %{"player" => player, "sort" => sort}) do
    csv_content = CSVGenerator.generate(sort, player)

    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header(
      "content-disposition",
      "attachment; filename=\"rushing_stats.csv\""
    )
    |> send_resp(200, csv_content)
  end
end
