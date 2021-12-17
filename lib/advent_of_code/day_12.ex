defmodule AdventOfCode.Day12 do
  defp parse(input) do
    input
    |> String.split(["\r", "\n"], trim: true)
    |> Enum.map(fn row ->
      [start, stop] = String.split(row, "-")
      {start, stop}
    end)
    |> Enum.reduce(%{}, fn
      {start, stop}, acc ->
        acc
        |> Map.update(start, [stop], &[stop | &1])
        |> Map.update(stop, [start], &[start | &1])
    end)
  end

  defp bfs(_, "end", _, path), do: [Enum.reverse(path)]

  defp bfs(map, current, visited, path) do
    map[current]
    |> Enum.filter(fn cave ->
      cave == String.upcase(cave) or !(cave in visited)
    end)
    |> Enum.flat_map(fn neigh ->
      bfs(map, neigh, [neigh | visited], [neigh | path])
    end)
  end

  def part1(input) do
    input
    |> parse()
    |> bfs("start", ["start"], ["start"])
    |> Enum.count()
  end

  defp bfs_v2(_, "end", _, path, _), do: [Enum.reverse(path)]

  defp bfs_v2(map, current, visited, path, jolly_used) do
    map[current]
    |> Enum.map(fn cave ->
      cond do
        cave == "start" -> nil
        cave == String.upcase(cave) -> {cave, jolly_used}
        !(cave in visited) -> {cave, jolly_used}
        !jolly_used -> {cave, true}
        true -> nil
      end
    end)
    |> Enum.filter(fn
      nil -> false
      _ -> true
    end)
    |> Enum.flat_map(fn {neigh, jolly_used} ->
      bfs_v2(map, neigh, [neigh | visited], [neigh | path], jolly_used)
    end)
  end

  def part2(input) do
    input
    |> parse()
    |> bfs_v2("start", ["start"], ["start"], false)
    |> Enum.count()
  end
end
