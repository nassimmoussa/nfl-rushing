defmodule NflRushing.Helpers.FileReader do
  @moduledoc """
  helper for reading json files
  """

  def read_file(filepath \\ "./rushing.json") do
    with {:ok, body} <- File.read(filepath), {:ok, json} <- Jason.decode(body), do: {:ok, json}
  end
end
