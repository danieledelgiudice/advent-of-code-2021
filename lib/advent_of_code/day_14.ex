defmodule AdventOfCode.Day14 do
  defp parse(input) do
    [polymer_row, rules_rows] = String.split(input, ["\n\n", "\r\n\r\n"], trim: true)

    polymer =
      polymer_row
      |> String.to_charlist()

    chains =
      polymer
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.frequencies()

    rules =
      for row <- String.split(rules_rows, ["\n", "\r\n"], trim: true),
          into: %{} do
        [pair, inserted] = String.split(row, [" -> "], trim: true)
        {String.to_charlist(pair), String.to_charlist(inserted) |> hd()}
      end

    {polymer, chains, rules}
  end

  defp do_pair_insertion(chains, rules) do
    chains
    |> Enum.flat_map(fn {pair, freq} ->
      if Map.has_key?(rules, pair) do
        [a, b] = pair
        [{[a, rules[pair]], freq}, {[rules[pair], b], freq}]
      else
        [pair, freq]
      end
    end)
    |> Enum.group_by(fn {k, _} -> k end, fn {_, v} -> v end)
    |> Enum.map(fn {k, v} -> {k, Enum.sum(v)} end)
    |> Map.new()
  end

  defp do_n_pair_insertions(chains, rules, n \\ 1) do
    1..n
    |> Enum.reduce(chains, fn _, acc ->
      do_pair_insertion(acc, rules)
    end)
  end

  defp score(chains, first_char) do
    freq =
      chains
      |> Enum.group_by(fn {[_, c], _} -> c end, fn {_, v} -> v end)
      |> Enum.map(fn {k, v} -> {k, Enum.sum(v)} end)
      |> Enum.map(fn
        {^first_char, count} -> {first_char, count + 1}
        freq -> freq
      end)

    {_, most_common_count} = freq |> Enum.max_by(fn {_, v} -> v end)
    {_, least_common_count} = freq |> Enum.min_by(fn {_, v} -> v end)

    most_common_count - least_common_count
  end

  def part1(input) do
    {polymer, chains, rules} = parse(input)

    do_n_pair_insertions(chains, rules, 10)
    |> score(hd(polymer))
  end

  def part2(input) do
    {polymer, chains, rules} = parse(input)

    do_n_pair_insertions(chains, rules, 40)
    |> score(hd(polymer))
  end
end
