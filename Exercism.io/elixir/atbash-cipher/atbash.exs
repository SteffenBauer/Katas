defmodule Atbash do

  @spec encode(String.t) :: String.t
  def encode(plaintext) do
    plaintext |> cipher |> chunk
  end
  
  defp cipher(text) do
    text |> String.downcase 
         |> String.to_char_list
         |> Enum.filter(&(&1 in ?a..?z or &1 in ?0..?9))
         |> Enum.map(&translate/1)
  end
  
  defp translate(chr) when chr in ?a..?z, do: ?z-(chr-?a)
  defp translate(chr),                    do: chr
  
  @blocksize 5
  defp chunk(text) do
    text |> Enum.chunk(@blocksize, @blocksize, [])
         |> Enum.reduce(&(&2 ++ ' ' ++ &1))
         |> List.to_string
  end

end
