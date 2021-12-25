import Bitwise

defmodule AdventOfCode.Day16 do
  @type_id_sum 0
  @type_id_product 1
  @type_id_minimum 2
  @type_id_maximum 3
  @type_id_literal 4
  @type_id_greater_than 5
  @type_id_less_than 6
  @type_id_equal_to 7

  defp parse(input) do
    {packet, _} =
      input
      |> String.trim()
      |> Base.decode16!()
      |> parse_packet()

    packet
  end

  defp parse_packet(packet) do
    <<version::3, type::3, rest::bits>> = packet

    {payload, rest} =
      case type do
        @type_id_literal ->
          {literal, rest} = parse_literal(rest)
          {%{literal: literal}, rest}

        _ ->
          {subpackets, rest} = parse_operator(rest)
          {%{subpackets: subpackets}, rest}
      end

    {Map.merge(%{version: version, type: type}, payload), rest}
  end

  ####

  defp parse_literal(payload, acc \\ 0)

  defp parse_literal(<<1::1, n::4, rest::bits>>, acc),
    do: parse_literal(rest, (acc <<< 4) + n)

  defp parse_literal(<<0::1, n::4, rest::bits>>, acc), do: {(acc <<< 4) + n, rest}

  ####

  defp parse_operator(<<0::1, length::15, rest::bits>>) do
    <<subpackets_data::bits-size(length), rest::bits>> = rest

    subpackets =
      1..10000
      |> Enum.reduce_while({[], subpackets_data}, fn
        _, {packets, <<>>} ->
          {:halt, packets}

        _, {packets, rest} ->
          {packet, rest} = parse_packet(rest)
          {:cont, {[packet | packets], rest}}
      end)

    {Enum.reverse(subpackets), rest}
  end

  defp parse_operator(<<1::1, count::11, rest::bits>>) do
    {subpackets, rest} =
      1..count
      |> Enum.reduce({[], rest}, fn
        _, {packets, rest} ->
          {packet, rest} = parse_packet(rest)
          {[packet | packets], rest}
      end)

    {Enum.reverse(subpackets), rest}
  end

  ###

  defp sum_versions(%{type: @type_id_literal, version: version}), do: version

  defp sum_versions(%{version: version, subpackets: subpackets}) do
    subpackets
    |> Enum.map(&sum_versions/1)
    |> Enum.sum()
    |> then(&(&1 + version))
  end

  ###

  defp packet_score(%{type: @type_id_sum, subpackets: subpackets}) do
    subpackets
    |> Enum.map(&packet_score/1)
    |> Enum.sum()
  end

  defp packet_score(%{type: @type_id_product, subpackets: subpackets}) do
    subpackets
    |> Enum.map(&packet_score/1)
    |> Enum.product()
  end

  defp packet_score(%{type: @type_id_minimum, subpackets: subpackets}) do
    subpackets
    |> Enum.map(&packet_score/1)
    |> Enum.min()
  end

  defp packet_score(%{type: @type_id_maximum, subpackets: subpackets}) do
    subpackets
    |> Enum.map(&packet_score/1)
    |> Enum.max()
  end

  defp packet_score(%{type: @type_id_literal, literal: literal}), do: literal

  defp packet_score(%{type: @type_id_greater_than, subpackets: [a, b]}) do
    if packet_score(a) > packet_score(b) do
      1
    else
      0
    end
  end

  defp packet_score(%{type: @type_id_less_than, subpackets: [a, b]}) do
    if packet_score(a) < packet_score(b) do
      1
    else
      0
    end
  end

  defp packet_score(%{type: @type_id_equal_to, subpackets: [a, b]}) do
    if packet_score(a) == packet_score(b) do
      1
    else
      0
    end
  end

  ###

  def part1(input) do
    input
    |> parse()
    |> sum_versions()
  end

  def part2(input) do
    input
    |> parse()
    |> packet_score()
  end
end
