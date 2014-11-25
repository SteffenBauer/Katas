defmodule Prime do

  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer

  def nth(count) when count < 1 or not is_integer(count), do: raise ArgumentError
  def nth(count), do: nth(count, [2])

  def nth(1, primes),     do: hd primes
  def nth(count, primes), do: nth(count-1, [next_prime(primes) | primes])

  defp next_prime(primes), do: next_prime(1 + hd(primes), primes)
  defp next_prime(p, primes) do
    case is_prime?(p, primes) do
      true  -> p
      false -> next_prime(p+1, primes)
    end
  end

  defp is_prime?(p, primes) do
    Enum.all?(primes, &(rem(p, &1) != 0))
  end

end
