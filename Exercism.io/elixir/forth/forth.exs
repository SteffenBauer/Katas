defmodule Forth do
  @moduledoc "Forth Interpreter"

  defmodule EV do
    @moduledoc "Interpreter EV."

    defstruct [
      stack: [],
      words: %{},
      wordparse: false,
      currentword: nil,
      currentdef: []
    ]

    @typedoc "Stack list."
    @type stack ::     [any]

    @typedoc "Word map."
    @type words ::      map

    @typedoc "Forth Word"
    @type word :: any

    @typedoc "Wordparse flag."
    @type wordparse ::  boolean

    @typedoc "Current definition."
    @type currentdef :: [any]

    @typedoc "EV"
    @type t :: %__MODULE__{
      stack:       stack,
      words:       words,
      wordparse:   wordparse,
      currentword: word,
      currentdef:  currentdef
    }

    @doc ~S"""
    Returns new EV struct.

    ## Examples

      iex> Forth.new()
      %EV{stack: [], words: %{}, wordparse: false, currentword: nil, currentdef: []}

    """
    @spec new() :: t
    def new(), do: %EV{}
  end

  @typedoc "Binary forth token."
  @type token :: binary

  @doc false
  defdelegate new(), to: EV

  @doc """
  Evaluate a forth string.
  """
  @spec eval(EV.t, binary) :: EV.t
  def eval(%EV{} = ev, s) when is_binary(s) do
    ~r/[^\p{L}\p{N}\p{S}\p{P}]+/u
    |> Regex.split(s)
    |> Enum.map(&String.upcase/1)
    |> Enum.reduce(ev, &parse_forth/2)
  end

  @doc ~S"""
  Format a stack for output and consumption.

  ## Examples

    iex(1)> stack = Forth.new()
    iex(2)> Forth.format_stack(stack)
    ""

    iex(1)> stack = Forth.new() |> Map.put(:stack, ["a", "b", "c"])
    iex(2)> Forth.format_stack(stack)
    "c b a"
  """
  def format_stack(%EV{stack: stack}) do
    stack
    |> Enum.reverse()
    |> Enum.join(" ")
  end

  @spec parse_forth(token, EV.t) :: EV.t
  defp parse_forth("\\" <> _, %EV{} = ev), do: ev
  defp parse_forth(token, %EV{wordparse: true} = ev), do: parse_definition(token, ev)
  defp parse_forth(token, %EV{} = ev), do: parse_regular(token, ev)

  # Parses a definition.
  @spec parse_definition(token, EV.t) :: EV.t
  defp parse_definition(token, %EV{currentword: nil} = ev), do: parse_newword(token, ev)
  defp parse_definition(token, %EV{} = ev), do: parse_newdefinition(token, ev)

  @spec parse_newword(token, EV.t) :: EV.t | no_return
  defp parse_newword(token, %EV{} = ev) do
    cond do
      is_num?(token) -> raise Forth.InvalidWord
      true           -> %EV{ ev | currentword: token }
    end
  end

  defp parse_newdefinition(";",   %EV{} = ev), do: end_worddefinition(ev)
  defp parse_newdefinition(token, %EV{} = ev), do: %EV{ ev | currentdef: [token | ev.currentdef] }

  defp start_worddefinition(%EV{} = ev), do: %EV{ ev | wordparse:   true,
                                                       currentword: nil,
                                                       currentdef:  [] }
  defp end_worddefinition(%EV{} = ev) do
    newwords = Map.put ev.words, ev.currentword, Enum.reverse(ev.currentdef)
    %EV{ ev | :words       => newwords,
              :wordparse   => false,
              :currentword => nil,
              :currentdef  => [] }
  end

  defp do_worddefinition(token, %EV{} = ev) do
    ev.words[token] |> Enum.reduce(ev, &parse_regular/2)
  end

  # Regular parser.

  @spec parse_regular(token, EV.t) :: EV.t | no_return
  defp parse_regular(token, %EV{} = ev) do
    cond do
      is_word?(token, ev) -> do_worddefinition(token, ev)
      is_num?(token)      -> add_number(String.to_integer(token), ev)
      is_binary(token)    -> do_parse_regular(token, ev)
    end
  end

  defp do_parse_regular(":"   , %EV{} = ev), do:  start_worddefinition(ev)
  defp do_parse_regular("+"   , %EV{} = ev), do:  do_addition(ev)
  defp do_parse_regular("-"   , %EV{} = ev), do:  do_subtraction(ev)
  defp do_parse_regular("*"   , %EV{} = ev), do:  do_multiplication(ev)
  defp do_parse_regular("/"   , %EV{} = ev), do:  do_division(ev)
  defp do_parse_regular("DUP" , %EV{} = ev), do:  do_dup(ev)
  defp do_parse_regular("DROP", %EV{} = ev), do:  do_drop(ev)
  defp do_parse_regular("SWAP", %EV{} = ev), do:  do_swap(ev)
  defp do_parse_regular("OVER", %EV{} = ev), do:  do_over(ev)
  defp do_parse_regular(token , _), do: raise Forth.UnknownWord, token

  defp is_word?(token, %EV{words: words}), do: words[token] != nil
  defp is_num?(token), do: Integer.parse(token) != :error

  defp add_number(num, ev), do: %EV { ev | :stack => [num|ev.stack] }

  defp do_addition(%EV{stack: [h1, h2 | t]} = ev), do: %EV{ev | stack: [h2 + h1| t]}
  defp do_addition(_), do: raise Forth.StackUnderflow


  defp do_subtraction(%EV{stack: [h1, h2 | t]} = ev), do: %EV{ev | stack: [h2 - h1| t]}
  defp do_subtraction(_), do: raise Forth.StackUnderflow

  defp do_multiplication(%EV{stack: [h1, h2 | t]} = ev), do: %EV{ev | stack: [h2 * h1| t]}
  defp do_multiplication(_), do: raise Forth.StackUnderflow

  defp do_division(%EV{stack: [0 | _]}), do: raise Forth.DivisionByZero
  defp do_division(%EV{stack: [h1, h2 | t]} = ev), do: %EV{ev | stack: [div(h2, h1)| t]}
  defp do_division(_), do: raise Forth.StackUnderflow

  defp do_dup(%EV{stack: [h | t]} = ev), do: %EV{ ev | stack: [h, h | t] }
  defp do_dup(_), do: raise Forth.StackUnderflow

  defp do_drop(%EV{stack: [_ | t]} = ev), do: %EV{ev | stack: t}
  defp do_drop(_), do: raise Forth.StackUnderflow

  defp do_swap(%EV{stack: [h1, h2 | t]} = ev), do: %EV{ev | stack: [h2, h1 | t]}
  defp do_swap(_), do: raise Forth.StackUnderflow

  defp do_over(%EV{stack: [h1,  h2 | t]} = ev), do: %EV{ev | stack: [h2, h1, h2 | t]}
  defp do_over(_), do: raise Forth.StackUnderflow

#
#  Exceptions
#
  defmodule StackUnderflow do
    @moduledoc false
    defexception [:message]
    def exception(_), do: %StackUnderflow{message: "stack underflow"}
  end

  defmodule InvalidWord do
    @moduledoc false
    defexception [:message]
    def exception(word), do: %InvalidWord{message: "invalid word: #{inspect word}"}
  end

  defmodule UnknownWord do
    @moduledoc false
    defexception [:message]
    def exception(word), do: %UnknownWord{message: "unknown word: #{inspect word}"}
  end

  defmodule DivisionByZero do
    @moduledoc false
    defexception [:message]
    def exception(_), do: %DivisionByZero{message: "division by zero"}
  end

end
