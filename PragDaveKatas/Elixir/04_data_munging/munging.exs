#!/usr/bin/env elixir

defmodule Munging do

  def parse_file(filename, fields) do
    File.stream!(filename)
    |> Stream.map(&String.split/1)
    |> Stream.reject(&no_data_line?/1)
    |> Stream.map(&(parse_line &1, fields))
    |> Stream.map(&calc_diff/1)
    |> Enum.reduce({"", nil}, &get_smaller/2)
  end

  defp no_data_line?(line) do
    (line == []) or ((line |> hd |> Integer.parse) == :error)
  end

  defp parse_line(line, fields) do
    line
      |> get_field_content(fields)
      |> Enum.map(&to_integer/1)
      |> list_to_tuple
  end

  defp get_field_content(line, fields) do
    Enum.map fields, &(Enum.at line, &1)
  end

  defp to_integer(e) do
    case Integer.parse(e) do
      :error   -> e
      { n, _ } -> n
    end
  end

  defp calc_diff({name, v1, v2}), do: {name, abs(v1 - v2)}

  defp get_smaller({n, diff}, {_an, adiff}) when diff < adiff, do: { n, diff }
  defp get_smaller(_e,        acc),                            do: acc

end

{day, spread} = Munging.parse_file "weather.dat", [0, 1, 2]
IO.puts "Day #{day} had the smallest temperature spread of #{spread}"

{team, difference} = Munging.parse_file "football.dat", [1, 6, 8]
IO.puts "Team #{team} had the smallest difference between for and against goals of #{difference}"

