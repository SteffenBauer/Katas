defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest. 
  """
  @spec factors_for(pos_integer) :: [pos_integer]

  def factors_for(number) do
    get_factors(number, 2, []) |> Enum.reverse
  end

  def get_factors(1, _, acc), do: acc
  def get_factors(number, test_factor, acc) do
    case rem(number, test_factor) do
      0 -> get_factors(div(number,test_factor), test_factor, [test_factor|acc])
      _ -> get_factors(number, test_factor+1, acc)
    end
  end

end
