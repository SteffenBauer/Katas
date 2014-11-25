defmodule Series do

  @doc """
  Splits up the given string of numbers into an array of integers.
  """
  @spec digits(String.t) :: [non_neg_integer]
  def digits(number_string) do
    number_string
      |> to_char_list
      |> Enum.filter(&(&1 in ?0..?9))
      |> Enum.map(&(&1 - ?0))
  end

  @doc """
  Generates sublists of a given size from a given string of numbers.
  """
  @spec slices(String.t, non_neg_integer) :: [list(non_neg_integer)]
  def slices(number_string, size) do
    number_string
      |> digits
      |> Enum.chunk(size, 1)
  end

  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t, non_neg_integer) :: non_neg_integer
  def largest_product(_number_string, 0), do: 1
  def largest_product( number_string, size) do
    number_string
      |> slices(size)
      |> Enum.map(&product/1)
      |> Enum.max
  end
  defp product(l), do: Enum.reduce(l, &(&1*&2))
  
end
