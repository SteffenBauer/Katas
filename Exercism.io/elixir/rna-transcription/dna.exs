defmodule DNA do
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> DNA.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    transcription = %{ ?A => ?U, ?C => ?G, ?T => ?A, ?G => ?C }
    Enum.map(dna, &(transcription[&1]))
  end
  
end
