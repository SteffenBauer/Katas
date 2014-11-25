defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t) :: map() 
  def count(sentence) do

    split = &(Regex.split(~r/[^\p{L&}\p{Nd}-]+/u, &1, trim: true))

    sentence 
      |> String.downcase
      |> split.()
      |> Enum.reduce(%{}, fn(word, map) -> Map.update(map, word, 1, &(&1+1)) end)
  end

end
