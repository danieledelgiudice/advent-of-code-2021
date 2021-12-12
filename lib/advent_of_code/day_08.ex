defmodule AdventOfCode.Day08 do
  defp parse(input) do
    input
    |> String.split(["\n", "\r\n"], trim: true)
    |> Enum.map(fn line ->
      [wires, digits] = String.split(line, " | ")
      {parse_sequence(wires), parse_sequence(digits)}
    end)
  end

  defp parse_sequence(sequence) do
    sequence
    |> String.split(" ")
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&Enum.sort/1)
  end

  def part1(input) do
    input
    |> parse()
    |> Enum.map(fn {_, digits} ->
      Enum.count(digits, &(length(&1) in [2, 3, 4, 7]))
    end)
    |> Enum.sum()
  end

  defp solve_display({wires, digits}) do
    d1 = wires |> Enum.find(&(length(&1) == 2))
    d4 = wires |> Enum.find(&(length(&1) == 4))

    digits
    |> Enum.map(fn d ->
      case {length(d), common_count(d, d1), common_count(d, d4)} do
        {2, _, _} -> 1
        {3, _, _} -> 7
        {4, _, _} -> 4
        {7, _, _} -> 8
        {5, _, 2} -> 2
        {5, 1, 3} -> 5
        {5, 2, 3} -> 3
        {6, _, 4} -> 9
        {6, 1, 3} -> 6
        {6, 2, 3} -> 0
      end
    end)
    |> Enum.reduce(fn d, acc -> acc * 10 + d end)
  end

  defp common_count(d1, d2) do
    MapSet.intersection(MapSet.new(d1), MapSet.new(d2))
    |> MapSet.size()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.map(&solve_display/1)
    |> Enum.sum()
  end

  # Old solution, it works but eeh
  # defp solve_display({wires, digits}) do
  #   d1 = wires |> Enum.find(&(length(&1) == 2))
  #   d4 = wires |> Enum.find(&(length(&1) == 4))
  #   d7 = wires |> Enum.find(&(length(&1) == 3))
  #   d8 = wires |> Enum.find(&(length(&1) == 7))

  #   hard = wires -- [d1, d4, d7, d8]

  #   freq =
  #     hard
  #     |> Enum.concat()
  #     |> Enum.frequencies()

  #   {sE, _} = freq |> Enum.find(fn {_k, v} -> v == 3 end)
  #   sBF = freq |> Enum.filter(fn {_k, v} -> v == 4 end) |> Enum.map(fn {k, _v} -> k end)
  #   sCG = freq |> Enum.filter(fn {_k, v} -> v == 5 end) |> Enum.map(fn {k, _v} -> k end)
  #   sAD = freq |> Enum.filter(fn {_k, v} -> v == 6 end) |> Enum.map(fn {k, _v} -> k end)

  #   {[sB], [sF]} = Enum.split_with(sBF, fn s -> s in d1 end)
  #   [sA] = d7 -- d1
  #   [sD] = sAD -- [sA]
  #   [sC] = d1 -- [sB]
  #   [sG] = sCG -- [sC]

  #   d0 = Enum.sort([sA, sB, sC, sD, sE, sF])
  #   d2 = Enum.sort([sA, sB, sE, sD, sG])
  #   d3 = Enum.sort([sA, sB, sC, sD, sG])
  #   d5 = Enum.sort([sA, sC, sD, sF, sG])
  #   d6 = Enum.sort([sA, sC, sD, sE, sF, sG])
  #   d9 = Enum.sort([sA, sB, sC, sD, sF, sG])

  #   solution = [d0, d1, d2, d3, d4, d5, d6, d7, d8, d9]

  #   digits
  #   |> Enum.map(&Enum.find_index(solution, fn d -> d == &1 end))
  #   |> Enum.reduce(fn d, acc -> acc * 10 + d end)
  # end
end
