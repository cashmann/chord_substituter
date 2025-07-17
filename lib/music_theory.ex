defmodule ChordSubstituter.MusicTheory do
  @moduledoc """
  Utility module containing music theory constants and common operations.
  Provides note names, enharmonic equivalents, and utility functions
  for working with musical notes and qualities.
  """

  @note_names ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

  @enharmonic_equivalents %{
    "Db" => "C#",
    "Eb" => "D#",
    "Gb" => "F#",
    "Ab" => "G#",
    "Bb" => "A#",
    "E#" => "F",
    "B#" => "C"
  }

  @doc """
  Returns the list of note names in chromatic order.
  """
  def note_names, do: @note_names

  @doc """
  Returns the map of enharmonic equivalents.
  """
  def enharmonic_equivalents, do: @enharmonic_equivalents

  @doc """
  Normalizes a note by converting enharmonic equivalents to their standard form.

  ## Examples

      iex> MusicTheory.normalize_note("Db")
      "C#"

      iex> MusicTheory.normalize_note("C")
      "C"
  """
  def normalize_note(note) do
    Map.get(@enharmonic_equivalents, note, note)
  end

  @doc """
  Returns the index of a note in the chromatic scale (0-11).
  Handles enharmonic equivalents.

  ## Examples

      iex> MusicTheory.note_index("C")
      0

      iex> MusicTheory.note_index("Db")
      1
  """
  def note_index(note) do
    normalized_note = normalize_note(note)
    Enum.find_index(@note_names, &(&1 == normalized_note))
  end

  @doc """
  Normalizes a chord quality by trimming whitespace and converting to lowercase.

  ## Examples

      iex> MusicTheory.normalize_quality("  MAJOR7  ")
      "major7"

      iex> MusicTheory.normalize_quality("Dom7")
      "dom7"
  """
  def normalize_quality(quality) do
    String.downcase(quality) |> String.trim()
  end

  @doc """
  Calculates the note that is a given number of semitones away from the root note.

  ## Examples

      iex> MusicTheory.transpose_note("C", 6)
      "F#"

      iex> MusicTheory.transpose_note("G", 6)
      "C#"
  """
  def transpose_note(root, semitones) do
    case note_index(root) do
      nil -> {:error, "Invalid root note: #{root}"}
      root_index ->
        target_index = rem(root_index + semitones, length(@note_names))
        target_note = Enum.at(@note_names, target_index)
        {:ok, target_note}
    end
  end

  @doc """
  Checks if a note is valid (exists in the chromatic scale or enharmonic equivalents).

  ## Examples

      iex> MusicTheory.valid_note?("C")
      true

      iex> MusicTheory.valid_note?("Db")
      true

      iex> MusicTheory.valid_note?("H")
      false
  """
  def valid_note?(note) do
    Enum.member?(@note_names, note) or Map.has_key?(@enharmonic_equivalents, note)
  end
end
