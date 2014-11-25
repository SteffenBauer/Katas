defmodule Scrabble do
  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t) :: non_neg_integer
  def score(word) do
    word |> String.downcase 
         |> String.codepoints
         |> Enum.map(&(get_letter_score(&1)))
         |> Enum.sum
  end

  def get_letter_score(letter) do
    cond do
      letter in ["a","e","i","o","u","l","n","r","s","t"] -> 1
      letter in ["d","g"]                                 -> 2
      letter in ["b","c","m","p"]                         -> 3
      letter in ["f","h","v","w","y"]                     -> 4
      letter in ["k"]                                     -> 5
      letter in ["j","x"]                                 -> 8
      letter in ["q","z"]                                 -> 10
      true                                                -> 0
    end
  end

end
