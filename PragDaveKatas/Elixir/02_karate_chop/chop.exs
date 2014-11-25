#!/usr/bin/env elixir

defmodule Chop do
  import Enum
  
  def chop0(search_value, search_array) do
    case find_index search_array, &(&1 == search_value) do
      nil   -> -1
      value -> value
    end
  end
  
  def chop1(search_value, search_array) do
    _chop1 search_value, search_array, 0, count(search_array)-1
  end
  
  defp _chop1(sv, sa, lower, upper) do
    half = div lower + upper, 2
    cond do
      lower > upper     -> -1
      sv == at sa, half -> half
      sv <  at sa, half -> _chop1 sv, sa, lower, half - 1
      true              -> _chop1 sv, sa, half + 1, upper
    end
  end
  
  def chop2(sv, sa) do 
    half = div count(sa), 2
    offset = &(if &1 >= 0, do: &1+1+half, else: -1)
    cond do
      sa == []          -> -1
      sv == at sa, half -> half
      sv <  at sa, half -> chop2(sv, slice(sa, 0, half))
      true              -> chop2(sv, slice(sa, half+1, count(sa)))
                        |> offset.()
    end
  end
  
  def chop3(sv, sa, offset \\ 0) do 
    half = div count(sa), 2
    cond do
      sa == []          -> -1
      sv == at sa, half -> offset + half
      sv <  at sa, half -> chop3 sv, slice(sa, 0, half), offset
      true              -> chop3 sv, slice(sa, half+1, count(sa)), offset+half+1
    end
  end

end

