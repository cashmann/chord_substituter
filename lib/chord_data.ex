defmodule ChordSubstituter.ChordData do
  @moduledoc """
  Contains chord interval mappings and quality abbreviations for the ChordSubstituter.
  """

  @interval_map %{
    "major" => [0, 4, 7],
    "minor" => [0, 3, 7],
    "diminished" => [0, 3, 6],
    "augmented" => [0, 4, 8],
    "major7" => [0, 4, 7, 11],
    "minor7" => [0, 3, 7, 10],
    "dominant7" => [0, 4, 7, 10],
    "diminished7" => [0, 3, 6, 9],
    "half_diminished7" => [0, 3, 6, 10],
    "major9" => [0, 4, 7, 11, 14],
    "minor9" => [0, 3, 7, 10, 14],
    "dominant9" => [0, 4, 7, 10, 14],
    "diminished9" => [0, 3, 6, 9, 13],
    "half_diminished9" => [0, 3, 6, 10, 13],
    "augmented9" => [0, 4, 8, 10, 14],
    "major11" => [0, 4, 7, 11, 14, 17],
    "minor11" => [0, 3, 7, 10, 14, 17],
    "dominant11" => [0, 4, 7, 10, 14, 17],
    "diminished11" => [0, 3, 6, 9, 13, 16],
    "half_diminished11" => [0, 3, 6, 10, 13, 16],
    "augmented11" => [0, 4, 8, 10, 14, 18],
    "major13" => [0, 4, 7, 11, 14, 17, 21],
    "minor13" => [0, 3, 7, 10, 14, 17, 21],
    "dominant13" => [0, 4, 7, 10, 14, 17, 21],
    "diminished13" => [0, 3, 6, 9, 13, 16, 20],
    "half_diminished13" => [0, 3, 6, 10, 13, 16, 20],
    "augmented13" => [0, 4, 8, 10, 14, 18, 21],
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
    "major7_sharp9" => [0, 4, 7, 11, 15],
    "major7_flat9" => [0, 4, 7, 11, 13],
    "major7_sharp11" => [0, 4, 7, 11, 18],
    "major9_sharp11" => [0, 4, 7, 11, 14, 18],
    "minor7_sharp9" => [0, 3, 7, 10, 15],
    "minor7_flat9" => [0, 3, 7, 10, 13],
    "minor9_sharp11" => [0, 3, 7, 10, 14, 18],
    "minor11_sharp9" => [0, 3, 7, 10, 15, 17],
    "sus2" => [0, 2, 7],
    "sus4" => [0, 5, 7],
    "7sus2" => [0, 2, 7, 10],
    "7sus4" => [0, 5, 7, 10],
    "maj7_sus2" => [0, 2, 7, 11],
    "maj7_sus4" => [0, 5, 7, 11],
    "9sus4" => [0, 5, 7, 10, 14],
    "maj9_sus4" => [0, 5, 7, 11, 14],
    "11sus2" => [0, 2, 7, 10, 14, 17],
    "maj11_sus2" => [0, 2, 7, 11, 14, 17],
    "13sus2" => [0, 2, 7, 10, 14, 17, 21],
    "13sus4" => [0, 5, 7, 10, 14, 17, 21],
    "maj13_sus2" => [0, 2, 7, 11, 14, 17, 21],
    "maj13_sus4" => [0, 5, 7, 11, 14, 17, 21]
  }

  @quality_abbreviations %{
    # Basic triads
    "maj" => "major",
    "min" => "minor",
    "m" => "minor",
    "dim" => "diminished",
    "°" => "diminished",
    "aug" => "augmented",
    "+" => "augmented",

    # 7th chords
    "maj7" => "major7",
    "min7" => "minor7",
    "m7" => "minor7",
    "-7" => "minor7",
    "7" => "dominant7",
    "dom7" => "dominant7",
    "dim7" => "diminished7",
    "°7" => "diminished7",
    "half_dim7" => "half_diminished7",
    "m7b5" => "half_diminished7",
    "ø7" => "half_diminished7",

    # 9th chords
    "maj9" => "major9",
    "min9" => "minor9",
    "m9" => "minor9",
    "-9" => "minor9",
    "9" => "dominant9",
    "dom9" => "dominant9",
    "dim9" => "diminished9",
    "°9" => "diminished9",
    "half_dim9" => "half_diminished9",
    "m9b5" => "half_diminished9",
    "ø9" => "half_diminished9",
    "aug9" => "augmented9",
    "+9" => "augmented9",

    # 11th chords
    "maj11" => "major11",
    "min11" => "minor11",
    "m11" => "minor11",
    "-11" => "minor11",
    "11" => "dominant11",
    "dom11" => "dominant11",
    "dim11" => "diminished11",
    "°11" => "diminished11",
    "half_dim11" => "half_diminished11",
    "m11b5" => "half_diminished11",
    "ø11" => "half_diminished11",
    "aug11" => "augmented11",
    "+11" => "augmented11",

    # 13th chords
    "maj13" => "major13",
    "min13" => "minor13",
    "m13" => "minor13",
    "-13" => "minor13",
    "13" => "dominant13",
    "dom13" => "dominant13",
    "dim13" => "diminished13",
    "°13" => "diminished13",
    "half_dim13" => "half_diminished13",
    "m13b5" => "half_diminished13",
    "ø13" => "half_diminished13",
    "aug13" => "augmented13",
    "+13" => "augmented13",

    # Altered chords
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
    "maj7#9" => "major7_sharp9",
    "maj7b9" => "major7_flat9",
    "maj7#11" => "major7_sharp11",
    "maj9#11" => "major9_sharp11",
    "m7#9" => "minor7_sharp9",
    "m7b9" => "minor7_flat9",
    "m9#11" => "minor9_sharp11",
    "m11#9" => "minor11_sharp9",

    # Suspended chords
    "sus" => "sus4",
    "sus2" => "sus2",
    "sus4" => "sus4",
    "7sus2" => "7sus2",
    "7sus4" => "7sus4",
    "7sus" => "7sus4",
    "maj7sus2" => "maj7_sus2",
    "maj7sus4" => "maj7_sus4",
    "maj7sus" => "maj7_sus4",
    "9sus4" => "9sus4",
    "9sus" => "9sus4",
    "maj9sus4" => "maj9_sus4",
    "maj9sus" => "maj9_sus4",
    "11sus2" => "11sus2",
    "maj11sus2" => "maj11_sus2",
    "13sus2" => "13sus2",
    "13sus4" => "13sus4",
    "13sus" => "13sus4",
    "maj13sus2" => "maj13_sus2",
    "maj13sus4" => "maj13_sus4",
    "maj13sus" => "maj13_sus4",
  }

  def interval_map, do: @interval_map
  def quality_abbreviations, do: @quality_abbreviations

  def get_intervals(quality) do
    case Map.get(@interval_map, quality) do
      nil -> {:error, "Unknown chord quality: #{quality}"}
      intervals -> {:ok, intervals}
    end
  end

  def expand_quality_abbreviation(quality) do
    Map.get(@quality_abbreviations, quality, quality)
  end
end
