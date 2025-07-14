defmodule ChordSubstituter.ChordDataTest do
  use ExUnit.Case, async: true
  alias ChordSubstituter.ChordData

  describe "get_intervals/1" do
    test "returns intervals for basic triads" do
      assert ChordData.get_intervals("major") == {:ok, [0, 4, 7]}
      assert ChordData.get_intervals("minor") == {:ok, [0, 3, 7]}
      assert ChordData.get_intervals("diminished") == {:ok, [0, 3, 6]}
      assert ChordData.get_intervals("augmented") == {:ok, [0, 4, 8]}
    end

    test "returns intervals for seventh chords" do
      assert ChordData.get_intervals("major7") == {:ok, [0, 4, 7, 11]}
      assert ChordData.get_intervals("minor7") == {:ok, [0, 3, 7, 10]}
      assert ChordData.get_intervals("dominant7") == {:ok, [0, 4, 7, 10]}
      assert ChordData.get_intervals("diminished7") == {:ok, [0, 3, 6, 9]}
      assert ChordData.get_intervals("half_diminished7") == {:ok, [0, 3, 6, 10]}
    end

    test "returns intervals for extended chords" do
      assert ChordData.get_intervals("major9") == {:ok, [0, 4, 7, 11, 14]}
      assert ChordData.get_intervals("minor11") == {:ok, [0, 3, 7, 10, 14, 17]}
      assert ChordData.get_intervals("dominant13") == {:ok, [0, 4, 7, 10, 14, 17, 21]}
    end

    test "returns intervals for altered chords" do
      assert ChordData.get_intervals("dominant7_sharp9") == {:ok, [0, 4, 7, 10, 15]}
      assert ChordData.get_intervals("dominant7_flat9") == {:ok, [0, 4, 7, 10, 13]}
      assert ChordData.get_intervals("dominant7_sharp11") == {:ok, [0, 4, 7, 10, 18]}
    end

    test "returns intervals for suspended chords" do
      assert ChordData.get_intervals("sus2") == {:ok, [0, 2, 7]}
      assert ChordData.get_intervals("sus4") == {:ok, [0, 5, 7]}
      assert ChordData.get_intervals("7sus4") == {:ok, [0, 5, 7, 10]}
      assert ChordData.get_intervals("maj7_sus2") == {:ok, [0, 2, 7, 11]}
    end

    test "defaults empty string to major" do
      assert ChordData.get_intervals("") == {:ok, [0, 4, 7]}
    end

    test "returns error for unknown chord quality" do
      assert ChordData.get_intervals("unknown") == {:error, "Unknown chord quality: unknown"}
      assert ChordData.get_intervals("nonsense") == {:error, "Unknown chord quality: nonsense"}
      assert ChordData.get_intervals("maj7invalid") == {:error, "Unknown chord quality: maj7invalid"}
    end

    test "handles nil input gracefully" do
      assert ChordData.get_intervals(nil) == {:error, "Unknown chord quality: "}
    end
  end

  describe "expand_quality_abbreviation/1" do
    test "expands basic triad abbreviations" do
      assert ChordData.expand_quality_abbreviation("maj") == "major"
      assert ChordData.expand_quality_abbreviation("min") == "minor"
      assert ChordData.expand_quality_abbreviation("m") == "minor"
      assert ChordData.expand_quality_abbreviation("dim") == "diminished"
      assert ChordData.expand_quality_abbreviation("°") == "diminished"
      assert ChordData.expand_quality_abbreviation("aug") == "augmented"
      assert ChordData.expand_quality_abbreviation("+") == "augmented"
    end

    test "expands seventh chord abbreviations" do
      assert ChordData.expand_quality_abbreviation("maj7") == "major7"
      assert ChordData.expand_quality_abbreviation("m7") == "minor7"
      assert ChordData.expand_quality_abbreviation("-7") == "minor7"
      assert ChordData.expand_quality_abbreviation("7") == "dominant7"
      assert ChordData.expand_quality_abbreviation("dim7") == "diminished7"
      assert ChordData.expand_quality_abbreviation("°7") == "diminished7"
      assert ChordData.expand_quality_abbreviation("m7b5") == "half_diminished7"
      assert ChordData.expand_quality_abbreviation("ø7") == "half_diminished7"
    end

    test "expands extended chord abbreviations" do
      assert ChordData.expand_quality_abbreviation("maj9") == "major9"
      assert ChordData.expand_quality_abbreviation("m9") == "minor9"
      assert ChordData.expand_quality_abbreviation("9") == "dominant9"
      assert ChordData.expand_quality_abbreviation("maj11") == "major11"
      assert ChordData.expand_quality_abbreviation("11") == "dominant11"
      assert ChordData.expand_quality_abbreviation("maj13") == "major13"
      assert ChordData.expand_quality_abbreviation("13") == "dominant13"
    end

    test "expands altered chord abbreviations" do
      assert ChordData.expand_quality_abbreviation("7#9") == "dominant7_sharp9"
      assert ChordData.expand_quality_abbreviation("7alt") == "dominant7_sharp9"
      assert ChordData.expand_quality_abbreviation("7b9") == "dominant7_flat9"
      assert ChordData.expand_quality_abbreviation("7#11") == "dominant7_sharp11"
      assert ChordData.expand_quality_abbreviation("13b9#11") == "dominant13_flat9_sharp11"
    end

    test "expands suspended chord abbreviations" do
      assert ChordData.expand_quality_abbreviation("sus") == "sus4"
      assert ChordData.expand_quality_abbreviation("sus2") == "sus2"
      assert ChordData.expand_quality_abbreviation("sus4") == "sus4"
      assert ChordData.expand_quality_abbreviation("7sus") == "7sus4"
      assert ChordData.expand_quality_abbreviation("maj7sus") == "maj7_sus4"
    end

    test "returns original quality if no abbreviation found" do
      assert ChordData.expand_quality_abbreviation("major") == "major"
      assert ChordData.expand_quality_abbreviation("unknown") == "unknown"
      assert ChordData.expand_quality_abbreviation("custom_chord") == "custom_chord"
    end

    test "handles empty string and nil" do
      assert ChordData.expand_quality_abbreviation("") == ""
      assert ChordData.expand_quality_abbreviation(nil) == nil
    end
  end

  describe "interval_map/0" do
    test "returns the complete interval mapping" do
      interval_map = ChordData.interval_map()

      assert is_map(interval_map)
      assert Map.has_key?(interval_map, "major")
      assert Map.has_key?(interval_map, "minor")
      assert Map.has_key?(interval_map, "diminished")
      assert Map.has_key?(interval_map, "augmented")
    end

    test "contains expected basic chord intervals" do
      interval_map = ChordData.interval_map()

      assert interval_map["major"] == [0, 4, 7]
      assert interval_map["minor"] == [0, 3, 7]
      assert interval_map["diminished"] == [0, 3, 6]
      assert interval_map["augmented"] == [0, 4, 8]
    end

    test "contains extended and altered chords" do
      interval_map = ChordData.interval_map()

      assert Map.has_key?(interval_map, "major7")
      assert Map.has_key?(interval_map, "dominant13")
      assert Map.has_key?(interval_map, "dominant7_sharp9")
      assert Map.has_key?(interval_map, "sus4")
    end

    test "all intervals are lists of integers" do
      interval_map = ChordData.interval_map()

      Enum.each(interval_map, fn {_quality, intervals} ->
        assert is_list(intervals)
        assert Enum.all?(intervals, &is_integer/1)
        assert Enum.all?(intervals, &(&1 >= 0))
      end)
    end
  end

  describe "quality_abbreviations/0" do
    test "returns the complete abbreviation mapping" do
      abbreviations = ChordData.quality_abbreviations()

      assert is_map(abbreviations)
      assert Map.has_key?(abbreviations, "maj")
      assert Map.has_key?(abbreviations, "m")
      assert Map.has_key?(abbreviations, "7")
      assert Map.has_key?(abbreviations, "sus")
    end

    test "contains expected basic abbreviations" do
      abbreviations = ChordData.quality_abbreviations()

      assert abbreviations["maj"] == "major"
      assert abbreviations["m"] == "minor"
      assert abbreviations["7"] == "dominant7"
      assert abbreviations["sus"] == "sus4"
    end

    test "contains symbol abbreviations" do
      abbreviations = ChordData.quality_abbreviations()

      assert abbreviations["°"] == "diminished"
      assert abbreviations["+"] == "augmented"
      assert abbreviations["ø7"] == "half_diminished7"
    end

    test "all abbreviations map to strings" do
      abbreviations = ChordData.quality_abbreviations()

      Enum.each(abbreviations, fn {abbrev, full_name} ->
        assert is_binary(abbrev)
        assert is_binary(full_name)
      end)
    end
  end
end
