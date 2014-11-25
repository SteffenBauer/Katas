defmodule Sieve do

  def primes_to(limit), do: get_primes(Enum.to_list(2..limit), [])

  defp get_primes([], primes),    do: primes |> Enum.reverse
  defp get_primes([h|t], primes), do: sieve(h, t, []) |> get_primes([h|primes])

  defp sieve(_,     [],    primes),                         do: primes |> Enum.reverse
  defp sieve(prime, [h|t], primes) when rem(h, prime) == 0, do: sieve(prime, t, primes)
  defp sieve(prime, [h|t], primes),                         do: sieve(prime, t, [h|primes])

end
