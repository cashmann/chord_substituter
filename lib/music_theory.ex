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
  @spec note_names() :: [String.t()]
  def note_names, do: @note_names

  @doc """
  Returns the map of enharmonic equivalents.
  """
  @spec enharmonic_equivalents() :: %{String.t() => String.t()}
  def enharmonic_equivalents, do: @enharmonic_equivalents

  @doc """
  Normalizes a note by converting enharmonic equivalents to their standard form.

  ## Examples

      iex> MusicTheory.get_enharmonic_equivalent("Db")
      "C#"

      iex> MusicTheory.get_enharmonic_equivalent("C")
      "C"
  """
  @spec get_enharmonic_equivalent(String.t()) :: String.t()
  def get_enharmonic_equivalent(note), do: Map.get(@enharmonic_equivalents, note, note)

  @doc """
  Returns the index of a note in the chromatic scale (0-11).
  Handles enharmonic equivalents.

  ## Examples

      iex> MusicTheory.note_index("C")
      0

      iex> MusicTheory.note_index("Db")
      1
  """
  @spec note_index(String.t()) :: non_neg_integer() | nil
  def note_index(note) do
    note
    |> get_enharmonic_equivalent()
    |> find_note_index()
  end

  @doc """
  Calculates the note that is a given number of semitones away from the root note.

  ## Examples

      iex> MusicTheory.transpose_note("C", 6)
      "F#"

      iex> MusicTheory.transpose_note("G", 6)
      "C#"
  """
  @spec transpose_note(String.t(), integer()) :: {:ok, String.t()} | {:error, String.t()}
  def transpose_note(root, semitones) do
    root
    |> note_index()
    |> calculate_transposed_note(semitones)
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
  @spec valid_note?(String.t()) :: boolean()
  def valid_note?(note) do
    Enum.member?(@note_names, note) or Map.has_key?(@enharmonic_equivalents, note)
  end

  @spec find_note_index(String.t()) :: non_neg_integer() | nil
  defp find_note_index(normalized_note), do: Enum.find_index(@note_names, &(&1 == normalized_note))

  @spec calculate_transposed_note(non_neg_integer() | nil, integer()) :: {:ok, String.t()} | {:error, String.t()}
  defp calculate_transposed_note(nil, _semitones), do: {:error, "Invalid root note"}
  defp calculate_transposed_note(root_index, semitones) when is_integer(root_index) and root_index >= 0 do
    target_index = rem(root_index + semitones, 12)  # Use constant instead of length calculation
    {:ok, Enum.at(@note_names, target_index)}
  end
end
