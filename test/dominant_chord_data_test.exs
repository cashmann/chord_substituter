defmodule ChordSubstituter.DominantChordDataTest do
  use ExUnit.Case, async: true
  alias ChordSubstituter.DominantChordData

  describe "get_intervals/1" do
    test "returns intervals for basic dominant chords" do
      assert DominantChordData.get_intervals("dominant7") == {:ok, [0, 4, 7, 10]}
      assert DominantChordData.get_intervals("dominant9") == {:ok, [0, 4, 7, 10, 14]}
      assert DominantChordData.get_intervals("dominant11") == {:ok, [0, 4, 7, 10, 14, 17]}
      assert DominantChordData.get_intervals("dominant13") == {:ok, [0, 4, 7, 10, 14, 17, 21]}
    end

    test "returns intervals for altered dominant chords" do
      assert DominantChordData.get_intervals("dominant7_sharp9") == {:ok, [0, 4, 7, 10, 15]}
      assert DominantChordData.get_intervals("dominant7_flat9") == {:ok, [0, 4, 7, 10, 13]}
      assert DominantChordData.get_intervals("dominant7_sharp11") == {:ok, [0, 4, 7, 10, 18]}
      assert DominantChordData.get_intervals("dominant9_sharp11") == {:ok, [0, 4, 7, 10, 14, 18]}
      assert DominantChordData.get_intervals("dominant13_flat9") == {:ok, [0, 4, 7, 10, 13, 17, 21]}
      assert DominantChordData.get_intervals("dominant13_sharp9") == {:ok, [0, 4, 7, 10, 15, 17, 21]}
      assert DominantChordData.get_intervals("dominant13_sharp11") == {:ok, [0, 4, 7, 10, 14, 18, 21]}
      assert DominantChordData.get_intervals("dominant13_flat9_sharp11") == {:ok, [0, 4, 7, 10, 13, 18, 21]}
      assert DominantChordData.get_intervals("dominant13_sharp9_sharp11") == {:ok, [0, 4, 7, 10, 15, 18, 21]}
      assert DominantChordData.get_intervals("dominant7_flat13") == {:ok, [0, 4, 7, 10, 20]}
      assert DominantChordData.get_intervals("dominant9_flat13") == {:ok, [0, 4, 7, 10, 14, 20]}
      assert DominantChordData.get_intervals("dominant11_flat13") == {:ok, [0, 4, 7, 10, 14, 17, 20]}
    end

    test "returns intervals for suspended dominant chords" do
      assert DominantChordData.get_intervals("7sus2") == {:ok, [0, 2, 7, 10]}
      assert DominantChordData.get_intervals("7sus4") == {:ok, [0, 5, 7, 10]}
      assert DominantChordData.get_intervals("9sus4") == {:ok, [0, 5, 7, 10, 14]}
      assert DominantChordData.get_intervals("13sus2") == {:ok, [0, 2, 7, 10, 14, 17, 21]}
      assert DominantChordData.get_intervals("13sus4") == {:ok, [0, 5, 7, 10, 14, 17, 21]}
    end

    test "returns error for non-dominant chord quality" do
      assert DominantChordData.get_intervals("major") == {:error, "Not a dominant chord quality: major"}
      assert DominantChordData.get_intervals("minor") == {:error, "Not a dominant chord quality: minor"}
      assert DominantChordData.get_intervals("diminished") == {:error, "Not a dominant chord quality: diminished"}
      assert DominantChordData.get_intervals("unknown") == {:error, "Not a dominant chord quality: unknown"}
    end

    test "handles nil input gracefully" do
      assert DominantChordData.get_intervals(nil) == {:error, "Not a dominant chord quality: "}
    end
  end

  describe "expand_quality_abbreviation/1" do
    test "expands basic dominant abbreviations" do
      assert DominantChordData.expand_quality_abbreviation("7") == "dominant7"
      assert DominantChordData.expand_quality_abbreviation("dom7") == "dominant7"
      assert DominantChordData.expand_quality_abbreviation("9") == "dominant9"
      assert DominantChordData.expand_quality_abbreviation("dom9") == "dominant9"
      assert DominantChordData.expand_quality_abbreviation("11") == "dominant11"
      assert DominantChordData.expand_quality_abbreviation("dom11") == "dominant11"
      assert DominantChordData.expand_quality_abbreviation("13") == "dominant13"
      assert DominantChordData.expand_quality_abbreviation("dom13") == "dominant13"
    end

    test "expands altered dominant abbreviations" do
      assert DominantChordData.expand_quality_abbreviation("7#9") == "dominant7_sharp9"
      assert DominantChordData.expand_quality_abbreviation("7alt") == "dominant7_sharp9"
      assert DominantChordData.expand_quality_abbreviation("7b9") == "dominant7_flat9"
      assert DominantChordData.expand_quality_abbreviation("9#11") == "dominant9_sharp11"
      assert DominantChordData.expand_quality_abbreviation("7#11") == "dominant7_sharp11"
      assert DominantChordData.expand_quality_abbreviation("13b9") == "dominant13_flat9"
      assert DominantChordData.expand_quality_abbreviation("13#9") == "dominant13_sharp9"
      assert DominantChordData.expand_quality_abbreviation("13#11") == "dominant13_sharp11"
      assert DominantChordData.expand_quality_abbreviation("13b9#11") == "dominant13_flat9_sharp11"
      assert DominantChordData.expand_quality_abbreviation("13#9#11") == "dominant13_sharp9_sharp11"
      assert DominantChordData.expand_quality_abbreviation("7b13") == "dominant7_flat13"
      assert DominantChordData.expand_quality_abbreviation("9b13") == "dominant9_flat13"
      assert DominantChordData.expand_quality_abbreviation("11b13") == "dominant11_flat13"
    end

    test "expands suspended dominant abbreviations" do
      assert DominantChordData.expand_quality_abbreviation("7sus2") == "7sus2"
      assert DominantChordData.expand_quality_abbreviation("7sus4") == "7sus4"
      assert DominantChordData.expand_quality_abbreviation("7sus") == "7sus4"
      assert DominantChordData.expand_quality_abbreviation("9sus4") == "9sus4"
      assert DominantChordData.expand_quality_abbreviation("9sus") == "9sus4"
      assert DominantChordData.expand_quality_abbreviation("13sus2") == "13sus2"
      assert DominantChordData.expand_quality_abbreviation("13sus4") == "13sus4"
      assert DominantChordData.expand_quality_abbreviation("13sus") == "13sus4"
    end

    test "returns original quality if no abbreviation found" do
      assert DominantChordData.expand_quality_abbreviation("dominant7") == "dominant7"
      assert DominantChordData.expand_quality_abbreviation("unknown") == "unknown"
      assert DominantChordData.expand_quality_abbreviation("custom_chord") == "custom_chord"
    end

    test "handles empty string and nil" do
      assert DominantChordData.expand_quality_abbreviation("") == ""
      assert DominantChordData.expand_quality_abbreviation(nil) == nil
    end
  end

  describe "is_dominant?/1" do
    test "returns true for basic dominant qualities" do
      assert DominantChordData.is_dominant?("7") == true
      assert DominantChordData.is_dominant?("dom7") == true
      assert DominantChordData.is_dominant?("dominant7") == true
      assert DominantChordData.is_dominant?("dominant") == true
      assert DominantChordData.is_dominant?("9") == true
      assert DominantChordData.is_dominant?("dom9") == true
      assert DominantChordData.is_dominant?("dominant9") == true
      assert DominantChordData.is_dominant?("11") == true
      assert DominantChordData.is_dominant?("dom11") == true
      assert DominantChordData.is_dominant?("dominant11") == true
      assert DominantChordData.is_dominant?("13") == true
      assert DominantChordData.is_dominant?("dom13") == true
      assert DominantChordData.is_dominant?("dominant13") == true
    end

    test "returns true for altered dominant qualities" do
      assert DominantChordData.is_dominant?("7#9") == true
      assert DominantChordData.is_dominant?("7alt") == true
      assert DominantChordData.is_dominant?("7b9") == true
      assert DominantChordData.is_dominant?("9#11") == true
      assert DominantChordData.is_dominant?("7#11") == true
      assert DominantChordData.is_dominant?("13b9") == true
      assert DominantChordData.is_dominant?("13#9") == true
      assert DominantChordData.is_dominant?("13#11") == true
      assert DominantChordData.is_dominant?("13b9#11") == true
      assert DominantChordData.is_dominant?("13#9#11") == true
      assert DominantChordData.is_dominant?("7b13") == true
      assert DominantChordData.is_dominant?("9b13") == true
      assert DominantChordData.is_dominant?("11b13") == true
      assert DominantChordData.is_dominant?("dominant7_sharp9") == true
      assert DominantChordData.is_dominant?("dominant7_flat9") == true
      assert DominantChordData.is_dominant?("dominant9_sharp11") == true
      assert DominantChordData.is_dominant?("dominant7_sharp11") == true
      assert DominantChordData.is_dominant?("dominant13_flat9") == true
      assert DominantChordData.is_dominant?("dominant13_sharp9") == true
      assert DominantChordData.is_dominant?("dominant13_sharp11") == true
      assert DominantChordData.is_dominant?("dominant13_flat9_sharp11") == true
      assert DominantChordData.is_dominant?("dominant13_sharp9_sharp11") == true
      assert DominantChordData.is_dominant?("dominant7_flat13") == true
      assert DominantChordData.is_dominant?("dominant9_flat13") == true
      assert DominantChordData.is_dominant?("dominant11_flat13") == true
    end

    test "returns true for suspended dominant qualities" do
      assert DominantChordData.is_dominant?("7sus2") == true
      assert DominantChordData.is_dominant?("7sus4") == true
      assert DominantChordData.is_dominant?("7sus") == true
      assert DominantChordData.is_dominant?("9sus4") == true
      assert DominantChordData.is_dominant?("9sus") == true
      assert DominantChordData.is_dominant?("13sus2") == true
      assert DominantChordData.is_dominant?("13sus4") == true
      assert DominantChordData.is_dominant?("13sus") == true
    end

    test "returns false for non-dominant qualities" do
      assert DominantChordData.is_dominant?("major") == false
      assert DominantChordData.is_dominant?("minor") == false
      assert DominantChordData.is_dominant?("diminished") == false
      assert DominantChordData.is_dominant?("augmented") == false
      assert DominantChordData.is_dominant?("major7") == false
      assert DominantChordData.is_dominant?("minor7") == false
      assert DominantChordData.is_dominant?("diminished7") == false
      assert DominantChordData.is_dominant?("half_diminished7") == false
      assert DominantChordData.is_dominant?("sus2") == false
      assert DominantChordData.is_dominant?("sus4") == false
      assert DominantChordData.is_dominant?("maj7sus2") == false
      assert DominantChordData.is_dominant?("maj7sus4") == false
      assert DominantChordData.is_dominant?("unknown") == false
      assert DominantChordData.is_dominant?("") == false
      assert DominantChordData.is_dominant?(nil) == false
    end
  end

  describe "dominant_qualities/0" do
    test "returns a list of all dominant qualities" do
      qualities = DominantChordData.dominant_qualities()

      assert is_list(qualities)
      assert length(qualities) > 0

      # Check some expected basic dominants
      assert "7" in qualities
      assert "dom7" in qualities
      assert "dominant7" in qualities
      assert "9" in qualities
      assert "11" in qualities
      assert "13" in qualities

      # Check some expected altered dominants
      assert "7#9" in qualities
      assert "7alt" in qualities
      assert "7b9" in qualities
      assert "dominant7_sharp9" in qualities
      assert "dominant7_flat9" in qualities

      # Check some expected suspended dominants
      assert "7sus2" in qualities
      assert "7sus4" in qualities
      assert "9sus4" in qualities
      assert "13sus2" in qualities
    end

    test "all qualities in list are valid dominants" do
      qualities = DominantChordData.dominant_qualities()

      Enum.each(qualities, fn quality ->
        assert DominantChordData.is_dominant?(quality) == true
      end)
    end
  end

  describe "interval_map/0" do
    test "returns the complete dominant interval mapping" do
      interval_map = DominantChordData.interval_map()

      assert is_map(interval_map)
      assert Map.has_key?(interval_map, "dominant7")
      assert Map.has_key?(interval_map, "dominant9")
      assert Map.has_key?(interval_map, "dominant11")
      assert Map.has_key?(interval_map, "dominant13")
    end

    test "contains expected dominant chord intervals" do
      interval_map = DominantChordData.interval_map()

      assert interval_map["dominant7"] == [0, 4, 7, 10]
      assert interval_map["dominant9"] == [0, 4, 7, 10, 14]
      assert interval_map["dominant11"] == [0, 4, 7, 10, 14, 17]
      assert interval_map["dominant13"] == [0, 4, 7, 10, 14, 17, 21]
    end

    test "contains altered and suspended dominants" do
      interval_map = DominantChordData.interval_map()

      assert Map.has_key?(interval_map, "dominant7_sharp9")
      assert Map.has_key?(interval_map, "dominant7_flat9")
      assert Map.has_key?(interval_map, "7sus2")
      assert Map.has_key?(interval_map, "7sus4")
      assert Map.has_key?(interval_map, "9sus4")
      assert Map.has_key?(interval_map, "13sus2")
      assert Map.has_key?(interval_map, "13sus4")
    end

    test "all intervals are lists of integers" do
      interval_map = DominantChordData.interval_map()

      Enum.each(interval_map, fn {_quality, intervals} ->
        assert is_list(intervals)
        assert Enum.all?(intervals, &is_integer/1)
        assert Enum.all?(intervals, &(&1 >= 0))
      end)
    end
  end

  describe "quality_abbreviations/0" do
    test "returns the complete dominant abbreviation mapping" do
      abbreviations = DominantChordData.quality_abbreviations()

      assert is_map(abbreviations)
      assert Map.has_key?(abbreviations, "7")
      assert Map.has_key?(abbreviations, "dom7")
      assert Map.has_key?(abbreviations, "9")
      assert Map.has_key?(abbreviations, "7#9")
      assert Map.has_key?(abbreviations, "7sus2")
    end

    test "contains expected dominant abbreviations" do
      abbreviations = DominantChordData.quality_abbreviations()

      assert abbreviations["7"] == "dominant7"
      assert abbreviations["dom7"] == "dominant7"
      assert abbreviations["9"] == "dominant9"
      assert abbreviations["dom9"] == "dominant9"
      assert abbreviations["11"] == "dominant11"
      assert abbreviations["13"] == "dominant13"
    end

    test "all abbreviations map to strings" do
      abbreviations = DominantChordData.quality_abbreviations()

      Enum.each(abbreviations, fn {abbrev, full_name} ->
        assert is_binary(abbrev)
        assert is_binary(full_name)
      end)
    end
  end
end
