defmodule ChordSubstituter.DominantChordData do
  @moduledoc """
  Contains chord interval mappings and quality abbreviations specifically for dominant chords.

  This module centralizes all dominant chord-related data that can be reused across
  different modules like ChordData and TritoneSubstitution.
  """

  @dominant_interval_map %{
    "dominant7" => [0, 4, 7, 10],
    "dominant9" => [0, 4, 7, 10, 14],
    "dominant11" => [0, 4, 7, 10, 14, 17],
    "dominant13" => [0, 4, 7, 10, 14, 17, 21],
    "dominant7_sharp9" => [0, 4, 7, 10, 15],
    "dominant7_flat9" => [0, 4, 7, 10, 13],
    "dominant9_sharp11" => [0, 4, 7, 10, 14, 18],
    "dominant7_sharp11" => [0, 4, 7, 10, 18],
    "dominant13_flat9" => [0, 4, 7, 10, 13, 17, 21],
    "dominant13_sharp9" => [0, 4, 7, 10, 15, 17, 21],
    "dominant13_sharp11" => [0, 4, 7, 10, 14, 18, 21],
    "dominant13_flat9_sharp11" => [0, 4, 7, 10, 13, 18, 21],
    "dominant13_sharp9_sharp11" => [0, 4, 7, 10, 15, 18, 21],
    "dominant7_flat13" => [0, 4, 7, 10, 20],
    "dominant9_flat13" => [0, 4, 7, 10, 14, 20],
    "dominant11_flat13" => [0, 4, 7, 10, 14, 17, 20],
    # Suspended dominant chords
    "7sus2" => [0, 2, 7, 10],
    "7sus4" => [0, 5, 7, 10],
    "9sus4" => [0, 5, 7, 10, 14],
    "13sus2" => [0, 2, 7, 10, 14, 17, 21],
    "13sus4" => [0, 5, 7, 10, 14, 17, 21]
  }

  @dominant_quality_abbreviations %{
    # Basic dominant chords
    "7" => "dominant7",
    "dom7" => "dominant7",
    "9" => "dominant9",
    "dom9" => "dominant9",
    "11" => "dominant11",
    "dom11" => "dominant11",
    "13" => "dominant13",
    "dom13" => "dominant13",
    # Altered dominant chords
    "7#9" => "dominant7_sharp9",
    "7alt" => "dominant7_sharp9",
    "7b9" => "dominant7_flat9",
    "9#11" => "dominant9_sharp11",
    "7#11" => "dominant7_sharp11",
    "13b9" => "dominant13_flat9",
    "13#9" => "dominant13_sharp9",
    "13#11" => "dominant13_sharp11",
    "13b9#11" => "dominant13_flat9_sharp11",
    "13#9#11" => "dominant13_sharp9_sharp11",
    "7b13" => "dominant7_flat13",
    "9b13" => "dominant9_flat13",
    "11b13" => "dominant11_flat13",
    # Suspended dominant chords
    "7sus2" => "7sus2",
    "7sus4" => "7sus4",
    "7sus" => "7sus4",
    "9sus4" => "9sus4",
    "9sus" => "9sus4",
    "13sus2" => "13sus2",
    "13sus4" => "13sus4",
    "13sus" => "13sus4"
  }

  @dominant_qualities [
    # Basic dominants
    "7", "dom7", "dominant7", "dominant",
    "9", "dom9", "dominant9",
    "11", "dom11", "dominant11",
    "13", "dom13", "dominant13",
    # Altered dominants
    "7#9", "7alt", "7b9", "9#11", "7#11", "13b9", "13#9", "13#11",
    "13b9#11", "13#9#11", "7b13", "9b13", "11b13",
    "dominant7_sharp9", "dominant7_flat9", "dominant9_sharp11",
    "dominant7_sharp11", "dominant13_flat9", "dominant13_sharp9",
    "dominant13_sharp11", "dominant13_flat9_sharp11", "dominant13_sharp9_sharp11",
    "dominant7_flat13", "dominant9_flat13", "dominant11_flat13",
    # Suspended dominants
    "7sus2", "7sus4", "7sus", "9sus4", "9sus", "13sus2", "13sus4", "13sus"
  ]

  @doc """
  Returns the complete mapping of dominant chord qualities to their intervals.
  """
  @spec interval_map() :: %{String.t() => [integer()]}
  def interval_map, do: @dominant_interval_map

  @doc """
  Returns the complete mapping of dominant chord abbreviations to their full names.
  """
  @spec quality_abbreviations() :: %{String.t() => String.t()}
  def quality_abbreviations, do: @dominant_quality_abbreviations

  @doc """
  Returns a list of all valid dominant chord qualities.
  """
  @spec dominant_qualities() :: [String.t()]
  def dominant_qualities, do: @dominant_qualities

  @doc """
  Gets the intervals for a dominant chord quality.

  Returns `{:ok, intervals}` if the quality is a valid dominant chord,
  or `{:error, reason}` if it's not a dominant chord.

  ## Examples

      iex> DominantChordData.get_intervals("dominant7")
      {:ok, [0, 4, 7, 10]}

      iex> DominantChordData.get_intervals("major")
      {:error, "Not a dominant chord quality: major"}
  """
  @spec get_intervals(String.t()) :: {:ok, [integer()]} | {:error, String.t()}
  def get_intervals(quality) do
    case Map.get(@dominant_interval_map, quality) do
      nil -> {:error, "Not a dominant chord quality: #{quality}"}
      intervals -> {:ok, intervals}
    end
  end

  @doc """
  Expands a dominant chord abbreviation to its full name.

  Returns the full quality name if the abbreviation is found,
  or the original quality if no abbreviation is found.

  ## Examples

      iex> DominantChordData.expand_quality_abbreviation("7")
      "dominant7"

      iex> DominantChordData.expand_quality_abbreviation("13#9")
      "dominant13_sharp9"

      iex> DominantChordData.expand_quality_abbreviation("unknown")
      "unknown"
  """
  @spec expand_quality_abbreviation(String.t()) :: String.t()
  def expand_quality_abbreviation(quality), do: Map.get(@dominant_quality_abbreviations, quality, quality)

  @doc """
  Checks if a quality is a valid dominant chord quality.

  ## Examples

      iex> DominantChordData.is_dominant?("7")
      true

      iex> DominantChordData.is_dominant?("dominant7")
      true

      iex> DominantChordData.is_dominant?("major")
      false
  """
  @spec is_dominant?(String.t()) :: boolean()
  def is_dominant?(quality), do: quality in @dominant_qualities
end
