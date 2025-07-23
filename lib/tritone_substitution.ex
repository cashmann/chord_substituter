defmodule ChordSubstituter.TritoneSubstitution do
  @moduledoc """
  Provides tritone substitution functionality for dominant 7th chords.

  A tritone substitution replaces a dominant 7th chord with another dominant 7th chord
  whose root is a tritone (6 semitones) away. This works because both chords share
  the same tritone interval (3rd and 7th degrees), just inverted.
  """

  alias ChordSubstituter.Chord
  alias ChordSubstituter.DominantChordData
  alias ChordSubstituter.MusicTheory


  @doc """
  Performs a tritone substitution on a dominant 7th chord.

  Takes a chord string and returns the tritone substitute chord name.
  Only works with dominant 7th chords (7, dom7, dominant7).

  ## Examples

      iex> TritoneSubstitution.substitute("G7")
      {:ok, "Db7"}

      iex> TritoneSubstitution.substitute("C dominant7")
      {:ok, "F# dominant7"}

      iex> TritoneSubstitution.substitute("C major")
      {:error, "Tritone substitution only applies to dominant 7th chords"}
  """
  @spec substitute(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def substitute(chord_string) do
    chord_string
    |> Chord.new()
    |> validate_and_substitute()
  end

  @doc """
  Performs a tritone substitution and returns both the chord name and its notes.

  Takes a chord string and returns a tuple with the substitute chord name and its notes.
  Only works with dominant 7th chords.

  ## Examples

      iex> TritoneSubstitution.substitute_with_notes("G7")
      {:ok, {"Db7", ["C#", "F", "G#", "B"]}}

      iex> TritoneSubstitution.substitute_with_notes("F# dominant7")
      {:ok, {"C dominant7", ["C", "E", "G", "A#"]}}
  """
  @spec substitute_with_notes(String.t()) :: {:ok, {String.t(), [String.t()]}} | {:error, String.t()}
  def substitute_with_notes(chord_string) do
    chord_string
    |> substitute()
    |> build_substitute_with_notes()
  end

  @spec validate_dominant_chord(Chord.t()) :: {:ok, :valid} | {:error, String.t()}
  defp validate_dominant_chord(%Chord{quality: quality}) do
    quality
    |> Chord.normalize_quality()
    |> is_valid_dominant_quality?()
    |> case do
      true -> {:ok, :valid}
      false -> {:error, "Tritone substitution only applies to dominant 7th chords"}
    end
  end

  @spec calculate_tritone_substitute(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  defp calculate_tritone_substitute(root), do: MusicTheory.transpose_note(root, 6)

  @spec format_quality_suffix(String.t()) :: String.t()
  defp format_quality_suffix(quality) do
    quality
    |> String.trim()
    |> do_format_quality_suffix()
  end

  @spec do_format_quality_suffix(String.t()) :: String.t()
  defp do_format_quality_suffix(""), do: "7"
  defp do_format_quality_suffix("dominant"), do: " dominant7"
  defp do_format_quality_suffix(quality) when quality in ["7", "9", "11", "13"], do: quality
  defp do_format_quality_suffix(quality) do
    if DominantChordData.is_dominant?(quality) do
      " " <> quality
    else
      quality
    end
  end

  @spec validate_and_substitute({:ok, Chord.t()} | {:error, String.t()}) :: {:ok, String.t()} | {:error, String.t()}
  defp validate_and_substitute({:ok, chord}) do
    with {:ok, _} <- validate_dominant_chord(chord),
         {:ok, substitute_root} <- calculate_tritone_substitute(chord.root) do
      {:ok, "#{substitute_root}#{format_quality_suffix(chord.quality)}"}
    end
  end
  defp validate_and_substitute({:error, reason}), do: {:error, reason}

  @spec build_substitute_with_notes({:ok, String.t()} | {:error, String.t()}) :: {:ok, {String.t(), [String.t()]}} | {:error, String.t()}
  defp build_substitute_with_notes({:ok, substitute_chord_name}) do
    substitute_chord_name
    |> Chord.notes()
    |> case do
      {:ok, notes} -> {:ok, {substitute_chord_name, notes}}
      {:error, reason} -> {:error, reason}
    end
  end
  defp build_substitute_with_notes({:error, reason}), do: {:error, reason}

  @spec is_valid_dominant_quality?(String.t()) :: boolean()
  defp is_valid_dominant_quality?(normalized_quality) do
    expanded_quality = DominantChordData.expand_quality_abbreviation(normalized_quality)
    DominantChordData.is_dominant?(normalized_quality) or
    DominantChordData.is_dominant?(expanded_quality) or
    normalized_quality == ""
  end
end
