defmodule AdventOfCode.Day15 do
  @dirs [{0, -1}, {1, 0}, {0, 1}, {-1, 0}]

  defp parse(input) do
    rows = String.split(input, ["\r", "\n"], trim: true)

    map =
      for {row, y} <- Enum.with_index(rows),
          {c, x} <- Enum.with_index(String.to_charlist(row)),
          into: %{} do
        {{x, y}, c - ?0}
      end

    destination = {
      Enum.count(rows) - 1,
      String.length(Enum.at(rows, 0)) - 1
    }

    {map, destination}
  end

  defp dijkstra(map, distances, queue) do
    if :gb_sets.is_empty(queue) do
      distances
    else
      {{current_dist, {x, y}}, queue} = :gb_sets.take_smallest(queue)

      neighbors_distances =
        @dirs
        |> Enum.map(fn {dx, dy} ->
          v = {x + dx, y + dy}
          {v, Map.get(map, v)}
        end)
        |> Enum.filter(fn {_, dist} -> dist != nil end)
        |> Enum.map(fn {v, dist} ->
          {v, current_dist + dist}
        end)
        |> Enum.filter(fn {v, dist} -> dist < distances[v] end)

      {distances, queue} =
        Enum.reduce(neighbors_distances, {distances, queue}, fn {v, dist}, {distances, queue} ->
          {Map.put(distances, v, dist), :gb_sets.add_element({dist, v}, queue)}
        end)

      dijkstra(map, distances, queue)
    end
  end

  def part1(input) do
    {map, destination} = parse(input)

    distances = Map.put(%{}, {0, 0}, 0)
    queue = :gb_sets.singleton({0, {0, 0}})

    dijkstra(map, distances, queue)
    |> then(& &1[destination])
  end

  defp upscale({map, {dest_x, dest_y}}) do
    width = dest_x + 1
    height = dest_y + 1

    map =
      for {{x, y}, risk} <- map, i <- 0..4, j <- 0..4, into: %{} do
        {{x + width * i, y + height * j}, rem(risk + i + j - 1, 9) + 1}
      end

    {map, {width * 5 - 1, height * 5 - 1}}
  end

  def part2(input) do
    {map, destination} =
      input
      |> parse()
      |> upscale()

    distances = Map.put(%{}, {0, 0}, 0)
    queue = :gb_sets.singleton({0, {0, 0}})

    dijkstra(map, distances, queue)
    |> then(& &1[destination])
  end
end
