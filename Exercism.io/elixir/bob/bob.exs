defmodule Teenager do

 defp rules do
    shout?    = fn p -> p == String.upcase(p) and p != String.downcase(p) end
    question? = fn p -> p |> String.ends_with? "?" end
    silence?  = fn p -> p |> String.strip |> String.length == 0 end
    default   = fn _ -> true end

    [{ shout?    , "Whoa, chill out!" },
     { question? , "Sure."},
     { silence?  , "Fine. Be that way!"}, 
     { default   , "Whatever."}]
  end
  
  defp answer(input, [{f,v}|t]) do
    if f.(input), do: v, else: answer(input, t)
  end

  def hey(input) do
    input |> answer(rules)
  end

end


