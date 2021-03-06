defmodule Grains do

  @doc """
  Calculate two to the power of the input minus one.
  """

  @spec square(pos_integer) :: pos_integer

  def  square(number), do: square(1, number)
  defp square(n, 1),   do: n
  defp square(n, c),   do: square(2*n,c-1)

  @doc """
  Adds square of each number from 1 to 64.
  """

  @spec total :: pos_integer

  def total do
    1..64 |> Enum.reduce(&(square(&1) + &2))
  end

  @doc """
  Add squares 1 to 64, speed-optimized
  """
  def total_speedy do
    1..64 |> Enum.reduce({1,0}, fn _,{n,sum} -> {n*2,sum+n} end) |> elem(1)
  end

end
