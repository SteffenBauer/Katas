defmodule Forth do
  @derive [Access]
  defstruct stack: [], words: %{}, wordparse: false, currentword: nil, currentdef: []

  def new(), do: %Forth{}

  def eval(ev, s) do
    Regex.split(~r/[^\p{L}\p{N}\p{S}\p{P}]+/u, s)
    |> Enum.reduce(ev, &parse_forth/2)
  end

  defp parse_forth(token, ev) do
    case ev[:wordparse] do
      true  -> parse_definition(token, ev)
      false -> parse_regular(token, ev)
    end
  end

#
#  Parser for new word definition
#
  defp parse_definition(token, ev) do
    token = String.upcase(token)
    case ev[:currentword] do
      nil -> parse_newword(token, ev)
      _   -> parse_newdefinition(token, ev)
    end
  end

  defp parse_newword(token, ev) do
    cond do
      is_num?(token) -> raise Forth.InvalidWord
      true           -> %Forth{ ev | :currentword => token }
    end
  end

  defp parse_newdefinition(token, ev) do
    cond do
      token == ";"    -> end_worddefinition(ev)
      true            -> %Forth{ ev | :currentdef => [token | ev[:currentdef]] }
    end
  end

  defp start_worddefinition(ev), do: %Forth{ ev | :wordparse => true, 
                                                  :currentword => nil, 
                                                  :currentdef => [] }
  defp end_worddefinition(ev) do
    newwords = Map.put ev[:words], ev[:currentword], Enum.reverse(ev[:currentdef])
    %Forth{ ev | :words => newwords,
                 :wordparse => false, 
                 :currentword => nil, 
                 :currentdef => [] }
  end

  defp do_worddefinition(token, ev) do
    ev[:words][token] |> Enum.reduce(ev, &parse_regular/2)
  end

#
#  Parser for regular tokens
#
  defp parse_regular(token, ev) do
    token = String.upcase(token)
    cond do
      is_word?(token, ev) -> do_worddefinition(token, ev)
      token == ":"        -> start_worddefinition(ev)
      is_num?(token)      -> add_number(String.to_integer(token), ev)
      token == "+"        -> do_addition(ev)
      token == "-"        -> do_subtraction(ev)
      token == "*"        -> do_multiplication(ev)
      token == "/"        -> do_division(ev)
      token == "DUP"      -> do_dup(ev)
      token == "DROP"     -> do_drop(ev)
      token == "SWAP"     -> do_swap(ev)
      token == "OVER"     -> do_over(ev)
      true                -> raise Forth.UnknownWord, token
    end
  end

  defp is_word?(token, ev), do: Map.has_key?(ev[:words], token)
  defp is_num?(token), do: Integer.parse(token) != :error

  defp add_number(num, ev), do: %Forth { ev | :stack => [num|ev[:stack]] }

  defp do_addition(ev)do
    case ev[:stack] do
      [h1,h2|t] -> %Forth{ ev | :stack => [h2+h1|t] }
      _         -> raise Forth.StackUnderflow
    end
  end
  
  defp do_subtraction(ev)do
    case ev[:stack] do
      [h1,h2|t] -> %Forth{ ev | :stack => [h2-h1|t] }
      _         -> raise Forth.StackUnderflow
    end
  end

  defp do_multiplication(ev)do
    case ev[:stack] do
      [h1,h2|t] -> %Forth{ ev | :stack => [h2*h1|t] }
      _         -> raise Forth.StackUnderflow
    end
  end

  defp do_division(ev)do
    case ev[:stack] do
      [0|_]     -> raise Forth.DivisionByZero
      [h1,h2|t] -> %Forth{ ev | :stack => [div(h2,h1)|t] }
      _         -> raise Forth.StackUnderflow
    end
  end

  defp do_dup(ev)do
    case ev[:stack] do
      [h|t] -> %Forth{ ev | :stack => [h,h|t] }
      _     -> raise Forth.StackUnderflow
    end
  end

  defp do_drop(ev)do
    case ev[:stack] do
      [_|t] -> %Forth{ ev | :stack => t }
      _     -> raise Forth.StackUnderflow
    end
  end

  defp do_swap(ev)do
    case ev[:stack] do
      [h1,h2|t] -> %Forth{ ev | :stack => [h2,h1|t] }
      _         -> raise Forth.StackUnderflow
    end
  end

  defp do_over(ev)do
    case ev[:stack] do
      [h1,h2|t] -> %Forth{ ev | :stack => [h2,h1,h2|t] }
      _         -> raise Forth.StackUnderflow
    end
  end

#
#  Format stack output
#
  def format_stack(ev), do: format_stack(Enum.reverse(ev[:stack]), "")
  defp format_stack([], fev), do: fev
  defp format_stack([h|t], fev) when t == [], do: fev <> to_string(h)
  defp format_stack([h|t], fev), do: format_stack(t, fev <> to_string(h) <> " ")

#
#  Exceptions
#
  defmodule StackUnderflow do
    defexception [:message]
    def exception(_), do: %StackUnderflow{message: "stack underflow"}
  end
  defmodule InvalidWord do
    defexception [:message]
    def exception(word), do: %InvalidWord{message: "invalid word: #{inspect word}"}
  end
  defmodule UnknownWord do
    defexception [:message]
    def exception(word), do: %UnknownWord{message: "unknown word: #{inspect word}"}
  end
  defmodule DivisionByZero do
    defexception [:message]
    def exception(_), do: %DivisionByZero{message: "division by zero"}
  end

end
