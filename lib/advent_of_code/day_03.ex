defmodule AdventOfCode.Day03 do
  use Bitwise

  defp parse(input) do
    input
    |> String.split()
    |> Enum.map(fn n ->
      n
      |> String.to_charlist()
      |> Enum.map(&(&1 - ?0))
    end)
  end

  def part1(input) do
    bits =
      input
      |> parse()
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&mode/1)

    gamma = bitlist_to_int(bits)
    sigma = bits |> Enum.map(&rem(&1 + 1, 2)) |> bitlist_to_int()

    gamma * sigma
  end

  defp mode(bits) do
    {zeros, ones} =
      Enum.reduce(bits, {0, 0}, fn
        0, {zeros, ones} -> {zeros + 1, ones}
        1, {zeros, ones} -> {zeros, ones + 1}
      end)

    if zeros > ones, do: 0, else: 1
  end

  defp bitlist_to_int(bits, acc \\ 0)
  defp bitlist_to_int([], acc), do: acc
  defp bitlist_to_int([bit | rest], acc), do: bitlist_to_int(rest, bit + acc * 2)

  def part2(input) do
    numbers = parse(input)

    o2 = do_part2(numbers, 0)
    co2 = do_part2(numbers, 1)

    o2 * co2
  end

  defp do_part2(numbers, swap, acc \\ [])
  defp do_part2([], _swap, acc), do: bitlist_to_int(acc)
  defp do_part2([x], swap, acc), do: do_part2([], swap, acc ++ x)

  defp do_part2(numbers, swap, acc) do
    criteria =
      numbers
      |> Enum.map(&List.first/1)
      |> mode()
      |> (&rem(&1 + swap, 2)).()

    new_numbers =
      numbers
      |> Enum.filter(&(List.first(&1) == criteria))
      |> Enum.map(fn [_ | rest] -> rest end)

    do_part2(new_numbers, swap, acc ++ [criteria])
  end
end
