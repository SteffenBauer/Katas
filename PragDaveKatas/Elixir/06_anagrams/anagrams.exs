#!/usr/bin/env elixir

parse_string  = &String.strip/1
word_and_idx  = &({&1, to_char_list(&1) |> :lists.sort |> to_string })
anagram_idx   = &(elem(&1,1))
anagram_word  = &(elem(&1,0))
sort_idx      = &(anagram_idx.(&1) < anagram_idx.(&2))
is_anagram?   = &(Enum.at(&1,1) != nil)
extract_word  = &(Enum.map(&1, anagram_word))

anagram_list = File.stream!("wordlist.txt")
            |> Stream.map(parse_string)
            |> Enum.map(word_and_idx)
            |> Enum.sort(sort_idx)
            |> Enum.chunk_by(anagram_idx)
            |> Enum.map(extract_word)
            |> Enum.filter(is_anagram?)

IO.puts "Found #{length(anagram_list)} anagrams"

find_longest = fn x,a when length(x) > length(a) -> x
                  _,a                            -> a
               end

longest = Enum.reduce(anagram_list, find_longest)
IO.puts "Longest anagram list is #{inspect longest} with #{inspect length(longest)} words"

