defmodule Anagram do

  def match(base, candidates) do
#    match_sequential(base, candidates)
    match_concurrent(base, candidates)
  end

# Sequential (non-concurrent) anagram finder

  defp match_sequential(base, candidates) do
    base = get_compareTuple(base)
    candidates
      |> Enum.filter(&(is_anagram?(&1, base)))
  end

  defp get_compareTuple(str) do
    cmpl = str |> String.downcase |> to_char_list
    cmps = cmpl |> Enum.sort
    { cmpl, cmps }
  end

  defp is_anagram?(candidate, {base, baseSorted}) do
    {cand, candSorted} = get_compareTuple(candidate)
    (cand !== base) && (candSorted === baseSorted)
  end

# Concurrent anagram finder
# using get_compareTuple/1 and is_anagram?/2 from sequential part

  defp match_concurrent(base, candidates) do
    base = get_compareTuple(base)
    candidates
      |> Enum.map(       &(start_anagram_tasks &1, base))
      |> Enum.reduce([], &(collect_anagrams(&1, &2)))
  end

  defp start_anagram_tasks(cand, base) do
    Task.async(fn -> anagram_task(cand, base) end)
  end

  defp collect_anagrams(task, anagrams) do
    anagrams ++ Task.await(task)
  end
  
  defp anagram_task(cand, base) do
    if is_anagram?(cand, base), do: [cand], else: []
  end

end
