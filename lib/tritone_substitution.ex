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
  def substitute(chord_string) do
    case Chord.new(chord_string) do
      %Chord{} = chord ->
        with {:ok, _} <- validate_dominant_chord(chord),
             {:ok, substitute_root} <- calculate_tritone_substitute(chord.root) do
          {:ok, "#{substitute_root}#{format_quality_suffix(chord.quality)}"}
        else
          {:error, reason} -> {:error, reason}
        end
      {:error, reason} -> {:error, reason}
    end
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
  def substitute_with_notes(chord_string) do
    case substitute(chord_string) do
      {:ok, substitute_chord_name} ->
        case Chord.notes(substitute_chord_name) do
          {:ok, notes} -> {:ok, {substitute_chord_name, notes}}
          {:error, reason} -> {:error, reason}
        end
      {:error, reason} -> {:error, reason}
    end
  end

  defp validate_dominant_chord(%Chord{quality: quality}) do
    normalized_quality = Chord.normalize_quality(quality)
    expanded_quality = DominantChordData.expand_quality_abbreviation(normalized_quality)

    if DominantChordData.is_dominant?(normalized_quality) or DominantChordData.is_dominant?(expanded_quality) or normalized_quality == "" do
      {:ok, :valid}
    else
      {:error, "Tritone substitution only applies to dominant 7th chords"}
    end
  end

  defp calculate_tritone_substitute(root) do
    MusicTheory.transpose_note(root, 6)
  end

  defp format_quality_suffix(quality) do
    trimmed = String.trim(quality)
    case trimmed do
      "" -> "7"
      "dominant" -> " dominant7"
      other when other in ["7", "9", "11", "13"] -> other
      other ->
        if DominantChordData.is_dominant?(other) do
          " " <> other
        else
          other
        end
    end
  end
end
