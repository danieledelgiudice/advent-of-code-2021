defmodule AdventOfCode.Day11 do
  @dirs [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  defp parse(input) do
    for {row, y} <- Enum.with_index(String.split(input, ["\r", "\n"], trim: true)),
        {c, x} <- Enum.with_index(String.to_charlist(row)),
        into: %{} do
      {{x, y}, c - ?0}
    end
  end

  defp ambient_light(map) do
    for {pos, light} <- map,
        into: %{} do
      {pos, light + 1}
    end
  end

  defp increase_light(:flash), do: :flash
  defp increase_light(n), do: n + 1

  defp check_light(map, {x, y}) do
    light = map[{x, y}]

    if light > 9 and light != :flash do
      map = Map.put(map, {x, y}, :flash)

      Enum.reduce(@dirs, map, fn {dx, dy}, acc ->
        neigh_pos = {x + dx, y + dy}

        if Map.has_key?(map, neigh_pos) do
          acc
          |> Map.update!(neigh_pos, &increase_light/1)
          |> check_light(neigh_pos)
        else
          acc
        end
      end)
    else
      map
    end
  end

  defp check_all_lights(map) do
    Enum.reduce(map, map, fn {pos, _}, acc ->
      check_light(acc, pos)
    end)
  end

  defp is_map_element_flash({_, :flash}), do: true
  defp is_map_element_flash(_), do: false

  defp reset_flashes(map) do
    for {pos, light} <- map,
        into: %{} do
      case light do
        :flash -> {pos, 0}
        n -> {pos, n}
      end
    end
  end

  defp step(map) do
    map
    # resetting here so we can count the flashes
    |> reset_flashes()
    |> ambient_light()
    |> check_all_lights()
  end

  def part1(input) do
    map = parse(input)

    {_, flashes} =
      Enum.reduce(0..99, {map, 0}, fn _, {acc, flashes} ->
        map = step(acc)

        new_flashes = Enum.count(map, &is_map_element_flash/1)

        {map, flashes + new_flashes}
      end)

    flashes
  end

  def part2(input) do
    map = parse(input)

    # Let's check up to the 1000th step
    1..1000
    |> Enum.reduce_while(map, fn i, acc ->
      map = step(acc)

      case Enum.all?(map, &is_map_element_flash/1) do
        true -> {:halt, i}
        false -> {:cont, map}
      end
    end)
  end
end
