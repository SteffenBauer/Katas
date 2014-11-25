#!/usr/bin/env elixir

defmodule Solitaire do
  
  def new_deck() do
    1..52 |> Enum.to_list
          |> List.insert_at(-1, :jokerA) 
          |> List.insert_at(-1, :jokerB)
  end

  defp movecard([x],   card, [h|newdeck]) when x == card, do: [h] ++ [card] ++ newdeck
  defp movecard([h|t], card,    newdeck)  when h == card, do: newdeck ++ [hd t] ++ [card] ++ (tl t)
  defp movecard([h|t], card,    newdeck),                 do: movecard(t, card, newdeck ++ [h])
  
  defp movecard(deck, card), do: movecard(deck, card, [])

  def move_jokers(deck) do
    deck |> movecard(:jokerA)
         |> movecard(:jokerB)
         |> movecard(:jokerB)
  end

  defp triplecut([h|t], joker1, nil, heap1, heap2) when is_atom(h), do: t ++ [joker1] ++ heap2 ++ [h] ++ heap1
  defp triplecut([h|t], joker1, nil, heap1, heap2),                 do: triplecut(t, joker1, nil, heap1, heap2 ++ [h])

  defp triplecut([h|t], nil, nil,    heap1) when is_atom(h), do: triplecut(t, h,   nil, heap1, [])
  defp triplecut([h|t], nil, nil,    heap1),                 do: triplecut(t, nil, nil, heap1 ++ [h])

  def triple_cut(deck), do: triplecut(deck, nil, nil, [])


  defp countcut(deck) do
    {d, [e]} = Enum.split(deck,-1)
    {n, t}   = Enum.split(d, e)
    t ++ n ++ [e]
  end
  def count_cut(deck) do
    cond do
      List.last(deck) |> is_atom -> deck
      true                       -> countcut(deck)
    end
  end

  defp getoutput(d, pos) do
    case Enum.at(d, pos) do
      card when is_atom(card) -> nil
      card                    -> card
    end
  end

  defp getoutput([h|t]) when is_atom(h), do: getoutput(t, -1)
  defp getoutput([h|t]),                 do: getoutput(t, h-1)

  def get_output(deck) do
    decknew = deck |> move_jokers
                   |> triple_cut
                   |> count_cut
    case getoutput(decknew) do
      nil   -> get_output(decknew)
      other -> {decknew, other}
    end
  end

  defp trim(num) when num > 26, do: trim(num-26)
  defp trim(num)              , do: num

  defp encrypt({deck, crypt}, char) do
    {decknew, num} = get_output(deck)
    nc = ?@ + trim(char + num)
    {decknew, crypt ++ to_char_list(<<nc>>)}
  end

  defp keyingcut(deck, pos) do
    {d, [e]} = Enum.split(deck, -1)
    {n, t} = Enum.split(d, pos)
    t ++ n ++ [e]
  end

  defp keycut(deck, char) do
    deck |> move_jokers
         |> triple_cut
         |> count_cut
         |> keyingcut(char - ?@)
  end

  def key_deck(deck, key) do
    Enum.reduce(key, deck, &(keycut(&2, &1)))
  end


  def encode(text, key) do
    deck = key_deck(new_deck, key)
    plain = Enum.map text, &(&1-?@)
    {_newdeck, crypt} = Enum.reduce(plain,{deck,[]},&(encrypt(&2,&1)))
    crypt
  end
  
  def decode(text, key) do
  
  end

end

plaintext = 'AAAAAAAAAAAAAAAAAAAAAAAAA'
key = 'CRYPTONOMICON'
IO.inspect Solitaire.encode(plaintext, key)


ExUnit.start

defmodule SolitaireTests do
  use ExUnit.Case, async: true
  
  test "Joker move tests" do
    deckbefore = [:jokerA,7,2,:jokerB,9,4,1]
    deckafter  = [7,:jokerA,2,9,4,:jokerB,1]
    assert deckbefore |> Solitaire.move_jokers == deckafter

    deckbefore = [3,:jokerA,:jokerB,8,9,6]
    deckafter  = [3,:jokerA,8,:jokerB,9,6]
    assert deckbefore |> Solitaire.move_jokers == deckafter

    deckbefore = [3,8,9,6,:jokerA,:jokerB]
    deckafter  = [3,:jokerB,8,9,6,:jokerA]
    assert deckbefore |> Solitaire.move_jokers == deckafter
  end

  test "Triple cut tests" do
    deckbefore = [2,4,6,:jokerB,5,8,7,1,:jokerA,3,9]
    deckafter  = [3,9,:jokerB,5,8,7,1,:jokerA,2,4,6]
    assert deckbefore |> Solitaire.triple_cut == deckafter

    deckbefore = [:jokerB,5,8,7,1,:jokerA,3,9]
    deckafter  = [3,9,:jokerB,5,8,7,1,:jokerA]
    assert deckbefore |> Solitaire.triple_cut == deckafter

    deckbefore = [:jokerB,5,8,7,1,:jokerA]
    deckafter  = [:jokerB,5,8,7,1,:jokerA]
    assert deckbefore |> Solitaire.triple_cut == deckafter
  end
  
  test "Count cut tests" do
    deckbefore = [7,1,3,:jokerA,6,12,16,18,4,:jokerB,5,8,9]
    deckafter  = [:jokerB,5,8,7,1,3,:jokerA,6,12,16,18,4,9]
    assert deckbefore |> Solitaire.count_cut == deckafter

    deckbefore = [7,1,3,:jokerA,6,12,16,18,4,5,8,9,:jokerB]
    deckafter  = [7,1,3,:jokerA,6,12,16,18,4,5,8,9,:jokerB]
    assert deckbefore |> Solitaire.count_cut == deckafter
    
    deckbefore = [:jokerB,2,3,4,52,:jokerA,1]
    deckafter  = [2,3,4,52,:jokerA,:jokerB,1]
    assert deckbefore |> Solitaire.count_cut == deckafter
    
  end
  
  test "Output test" do
    deckbefore = [7,1,3,:jokerA,6,12,16,18,4,:jokerB,5,8,9]
    deckafter = [5,8,:jokerB,7,1,3,9,:jokerA,12,16,18,4,6]
    assert deckbefore |> Solitaire.get_output == {deckafter, 3}
  end
  
  test "Encoding tests" do
    plaintext = 'AAAAAAAAAAAAAAA'
    key = ''
    crypttext = 'EXKYIZSGEHUNTIQ'
    assert Solitaire.encode(plaintext,key) == crypttext
    
    
  end
end
