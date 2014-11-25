defmodule Palindromes do

  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map() 
  def generate(max_factor, min_factor \\ 1) do
    (for a <- min_factor..max_factor,
         b <- a..max_factor,
         palindrome_product?(a,b), do: {a,b})
      |> Enum.reduce(HashDict.new, &update_palindromes/2)
  end

  defp update_palindromes({a,b}, palindromes) do
    { key, val } = { a*b, [[a,b]] }
    HashDict.update(palindromes, key, val, &(&1 ++ val))
  end

  defp palindrome_product?(a,b) do
    a*b |> Integer.to_char_list
        |> (&(&1 === &1 |> Enum.reverse)).()
  end

end
