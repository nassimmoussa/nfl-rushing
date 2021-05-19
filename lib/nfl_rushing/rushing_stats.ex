defmodule NflRushing.RushingStats do
  @moduledoc """
  context responsible for processing players rushing stats
  """

  @page_size 15

  alias NflRushing.Helpers.FileReader
  alias NflRushing.Schemas.PlayerRushingStats

  defstruct all_stats: nil,
            pagination: %{
              page_number: nil,
              total_entries: nil,
              total_pages: nil
            },
            paginated_rushing_stats: nil,
            sort_by: nil

  @spec get_rushing_stats(integer, String.t() | nil) :: %__MODULE__{}
  def get_rushing_stats(page, sort_by) do
    FileReader.read_file()
    |> format_players_stats()
    |> maybe_sort_stats(sort_by)
    |> add_pagination(page)
  end

  defp format_players_stats({:ok, players}) do
    %__MODULE__{all_stats: Enum.map(players, &PlayerRushingStats.new/1)}
  end

  defp add_pagination(%__MODULE__{all_stats: stats} = all_stats, page) do
    total_pages = ceil(length(stats) / @page_size)
    {rushing_stats, _rest} = stats |> Enum.chunk_every(@page_size) |> List.pop_at(page - 1)

    %__MODULE__{
      all_stats
      | paginated_rushing_stats: rushing_stats,
        pagination: %{
          page_number: page,
          total_entries: length(stats),
          total_pages: total_pages
        }
    }
  end

  defp maybe_sort_stats(rushin_stats, "asc_yds" = sort_by),
    do: %__MODULE__{
      rushin_stats
      | sort_by: sort_by,
        all_stats: asc_by_total_yards(rushin_stats.all_stats)
    }

  defp maybe_sort_stats(rushin_stats, "desc_yds" = sort_by),
    do: %__MODULE__{
      rushin_stats
      | sort_by: sort_by,
        all_stats: desc_by_total_yards(rushin_stats.all_stats)
    }

  defp maybe_sort_stats(rushin_stats, "asc_td" = sort_by),
    do: %__MODULE__{
      rushin_stats
      | sort_by: sort_by,
        all_stats: asc_by_total_rushing_touchdowns(rushin_stats.all_stats)
    }

  defp maybe_sort_stats(rushin_stats, "desc_td" = sort_by),
    do: %__MODULE__{
      rushin_stats
      | sort_by: sort_by,
        all_stats: desc_by_total_rushing_touchdowns(rushin_stats.all_stats)
    }

  defp maybe_sort_stats(rushin_stats, "asc_lng" = sort_by),
    do: %__MODULE__{
      rushin_stats
      | sort_by: sort_by,
        all_stats: asc_by_longest_rush(rushin_stats.all_stats)
    }

  defp maybe_sort_stats(rushin_stats, "desc_lng" = sort_by),
    do: %__MODULE__{
      rushin_stats
      | sort_by: sort_by,
        all_stats: desc_by_longest_rush(rushin_stats.all_stats)
    }

  defp maybe_sort_stats(rushin_stats, _), do: %__MODULE__{rushin_stats | sort_by: nil}

  defp asc_by_total_yards(stats), do: Enum.sort(stats, &(&1.total_yards <= &2.total_yards))
  defp desc_by_total_yards(stats), do: Enum.sort(stats, &(&1.total_yards >= &2.total_yards))

  defp asc_by_total_rushing_touchdowns(stats),
    do: Enum.sort(stats, &(&1.total_rushing_touchdowns <= &2.total_rushing_touchdowns))

  defp desc_by_total_rushing_touchdowns(stats),
    do: Enum.sort(stats, &(&1.total_rushing_touchdowns >= &2.total_rushing_touchdowns))

  defp asc_by_longest_rush(stats) do
    Enum.sort(stats, fn first, second ->
      first_longest_rush = parse_longest_rush(first.longest_rush)
      second_longest_rush = parse_longest_rush(second.longest_rush)

      first_longest_rush <= second_longest_rush
    end)
  end

  defp desc_by_longest_rush(stats) do
    Enum.sort(stats, fn first, second ->
      first_longest_rush = parse_longest_rush(first.longest_rush)
      second_longest_rush = parse_longest_rush(second.longest_rush)

      first_longest_rush >= second_longest_rush
    end)
  end

  defp parse_longest_rush(longest_rush) when is_integer(longest_rush), do: longest_rush

  defp parse_longest_rush(longest_rush) do
    {parsed, _} = Integer.parse(longest_rush)
    parsed
  end
end
