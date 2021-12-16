defmodule AdventOfCode.Day09 do
  @dirs [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

  defp parse(input) do
    for {row, y} <- Enum.with_index(String.split(input, ["\r", "\n"], trim: true)),
        {c, x} <- Enum.with_index(String.to_charlist(row)),
        into: %{} do
      {{x, y}, c - ?0}
    end
  end

  defp find_low(map) do
    map
    |> Enum.filter(fn {{x, y}, h} ->
      @dirs
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.map(&map[&1])
      |> Enum.all?(&(h < &1))
    end)
  end

  def part1(input) do
    input
    |> parse()
    |> find_low()
    |> Enum.map(fn {_pos, h} -> h + 1 end)
    |> Enum.sum()
  end

  defp scan_for_basin(_map, [], acc), do: acc

  defp scan_for_basin(map, [{x, y} | rest], acc) do
    neighbors =
      @dirs
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.filter(&(map[&1] < 9 and &1 not in acc))

    scan_for_basin(map, neighbors ++ rest, neighbors ++ acc)
  end

  def part2(input) do
    map = parse(input)

    map
    |> find_low()
    |> Enum.map(fn {pos, _} ->
      map
      |> scan_for_basin([pos], [pos])
      |> Enum.count()
    end)
    |> Enum.sort(:desc)
    |> Enum.slice(0, 3)
    |> Enum.product()
  end
end
