defmodule Frequency do

  @spec frequency([String.t], pos_integer) :: Dict.t
  def frequency(texts, workers) do
    pids = 1..workers |> Enum.map(fn _n -> new_worker end)

    texts |> Enum.join
          |> Stream.unfold(&String.next_codepoint/1)
          |> Enum.reduce({pids, pids}, &send_to_worker/2)

    freqs = Enum.reduce(pids, %{}, &collect_counts/2)
    pids |> Enum.each(&(Agent.stop(&1)))
    freqs
  end

  defp new_worker() do
    {:ok, worker} = Agent.start(fn -> %{} end)
    worker
  end

  defp send_to_worker(chr, {[h|t], workers}) do
    h |> Agent.update(&(count_letter(chr, &1)))
    case t do
      [] -> {workers, workers}
      _  -> {t, workers}
    end
  end

  defp collect_counts(pid, counts) do
    pid |> Agent.get(&(&1))
        |> Map.merge counts, fn _k, v1, v2 -> v1+v2 end
  end

  defp count_letter(chr, counts) do
    chr = String.downcase(chr)
    cond do
       Regex.match? ~r/\pL/, chr -> Map.update counts, chr, 1, &(&1+1)
       true                      -> counts
    end
  end
  
end
