defmodule ChordSubstituter.TritoneSubstitutionTest do
  use ExUnit.Case, async: true
  alias ChordSubstituter.TritoneSubstitution

  describe "substitute/1" do
    test "performs tritone substitution on basic dominant 7th chords" do
      assert TritoneSubstitution.substitute("G7") == {:ok, "C#7"}
      assert TritoneSubstitution.substitute("C7") == {:ok, "F#7"}
      assert TritoneSubstitution.substitute("D7") == {:ok, "G#7"}
      assert TritoneSubstitution.substitute("F7") == {:ok, "B7"}
    end

    test "handles dominant chord with full quality name" do
      assert TritoneSubstitution.substitute("G dominant7") == {:ok, "C# dominant7"}
      assert TritoneSubstitution.substitute("C dom7") == {:ok, "F# dom7"}
    end

    test "handles accidentals and enharmonic equivalents" do
      assert TritoneSubstitution.substitute("F#7") == {:ok, "C7"}
      assert TritoneSubstitution.substitute("A#7") == {:ok, "E7"}
      assert TritoneSubstitution.substitute("C#7") == {:ok, "G7"}
    end

    test "handles extended dominant chords" do
      assert TritoneSubstitution.substitute("G9") == {:ok, "C#9"}
      assert TritoneSubstitution.substitute("C13") == {:ok, "F#13"}
      assert TritoneSubstitution.substitute("D11") == {:ok, "G#11"}
    end

    test "handles altered dominant chords" do
      assert TritoneSubstitution.substitute("G7#9") == {:ok, "C# 7#9"}
      assert TritoneSubstitution.substitute("C7b9") == {:ok, "F# 7b9"}
      assert TritoneSubstitution.substitute("D7#11") == {:ok, "G# 7#11"}
      assert TritoneSubstitution.substitute("F7alt") == {:ok, "B 7alt"}
      assert TritoneSubstitution.substitute("A13b9") == {:ok, "D# 13b9"}
      assert TritoneSubstitution.substitute("E9#11") == {:ok, "A# 9#11"}
    end

    test "handles suspended dominant chords" do
      assert TritoneSubstitution.substitute("G7sus4") == {:ok, "C# 7sus4"}
      assert TritoneSubstitution.substitute("C7sus2") == {:ok, "F# 7sus2"}
      assert TritoneSubstitution.substitute("D7sus") == {:ok, "G# 7sus"}
      assert TritoneSubstitution.substitute("F9sus4") == {:ok, "B 9sus4"}
      assert TritoneSubstitution.substitute("A13sus2") == {:ok, "D# 13sus2"}
      assert TritoneSubstitution.substitute("E13sus4") == {:ok, "A# 13sus4"}
    end

    test "handles dominant chords with abbreviated notation" do
      assert TritoneSubstitution.substitute("Gdom7") == {:ok, "C# dom7"}
      assert TritoneSubstitution.substitute("Cdom9") == {:ok, "F# dom9"}
    end

    test "handles root note without quality (defaults to dominant)" do
      assert TritoneSubstitution.substitute("G") == {:ok, "C#7"}
      assert TritoneSubstitution.substitute("C") == {:ok, "F#7"}
    end

    test "returns error for non-dominant chords" do
      assert TritoneSubstitution.substitute("C major") == {:error, "Tritone substitution only applies to dominant 7th chords"}
      assert TritoneSubstitution.substitute("A minor") == {:error, "Tritone substitution only applies to dominant 7th chords"}
      assert TritoneSubstitution.substitute("F diminished") == {:error, "Tritone substitution only applies to dominant 7th chords"}
      assert TritoneSubstitution.substitute("G augmented") == {:error, "Tritone substitution only applies to dominant 7th chords"}
    end

    test "returns error for invalid chord format" do
      assert TritoneSubstitution.substitute("notachord") == {:error, "Invalid chord format"}
      assert TritoneSubstitution.substitute("") == {:error, "Invalid chord format"}
      assert TritoneSubstitution.substitute("H7") == {:error, "Invalid chord format"}
    end

    test "handles all 12 chromatic notes as roots" do
      expected_substitutions = %{
        "C7" => "F#7",
        "C#7" => "G7",
        "D7" => "G#7",
        "D#7" => "A7",
        "E7" => "A#7",
        "F7" => "B7",
        "F#7" => "C7",
        "G7" => "C#7",
        "G#7" => "D7",
        "A7" => "D#7",
        "A#7" => "E7",
        "B7" => "F7"
      }

      Enum.each(expected_substitutions, fn {input, expected} ->
        assert TritoneSubstitution.substitute(input) == {:ok, expected}
      end)
    end

    test "tritone substitution is its own inverse" do
      original_chords = ["C7", "F#7", "G7", "C#7", "D7", "G#7"]

      Enum.each(original_chords, fn chord ->
        {:ok, substitute} = TritoneSubstitution.substitute(chord)
        {:ok, double_substitute} = TritoneSubstitution.substitute(substitute)
        assert double_substitute == chord
      end)
    end
  end

  describe "substitute_with_notes/1" do
    test "returns substituted chord name and notes" do
      assert TritoneSubstitution.substitute_with_notes("G7") == {:ok, {"C#7", ["C#", "F", "G#", "B"]}}
      assert TritoneSubstitution.substitute_with_notes("C7") == {:ok, {"F#7", ["F#", "A#", "C#", "E"]}}
    end

    test "handles extended chords with notes" do
      {:ok, {"C#9", notes}} = TritoneSubstitution.substitute_with_notes("G9")
      assert "C#" in notes
      assert "F" in notes
      assert "G#" in notes
      assert "B" in notes
      assert "F" in notes  # 9th degree
    end

    test "returns error for non-dominant chords" do
      assert TritoneSubstitution.substitute_with_notes("C major") == {:error, "Tritone substitution only applies to dominant 7th chords"}
      assert TritoneSubstitution.substitute_with_notes("A minor") == {:error, "Tritone substitution only applies to dominant 7th chords"}
    end

    test "returns error for invalid chord format" do
      assert TritoneSubstitution.substitute_with_notes("notachord") == {:error, "Invalid chord format"}
      assert TritoneSubstitution.substitute_with_notes("") == {:error, "Invalid chord format"}
    end

    test "verifies that substituted chords share tritone interval" do
      {:ok, {"C#7", db7_notes}} = TritoneSubstitution.substitute_with_notes("G7")
      {:ok, g7_notes} = ChordSubstituter.Chord.notes("G7")

      # G7: G-B-D-F, C#7: C#-F-G#-B
      # They share F and B (the tritone from G7 becomes the 3rd and 7th of C#7)
      assert "F" in db7_notes
      assert "B" in db7_notes
      assert "B" in g7_notes
      assert "F" in g7_notes
    end
  end

  describe "edge cases and error handling" do
    test "handles enharmonic equivalents in input" do
      # C#7 should substitute to G7
      assert TritoneSubstitution.substitute("C#7") == {:ok, "G7"}
      assert TritoneSubstitution.substitute("D#7") == {:ok, "A7"}
      assert TritoneSubstitution.substitute("F#7") == {:ok, "C7"}
    end

    test "preserves original quality formatting" do
      assert TritoneSubstitution.substitute("G dominant7") == {:ok, "C# dominant7"}
      assert TritoneSubstitution.substitute("C dom7") == {:ok, "F# dom7"}
      assert TritoneSubstitution.substitute("D dominant9") == {:ok, "G# dominant9"}
    end

    test "handles whitespace in chord strings" do
      assert TritoneSubstitution.substitute("G  7") == {:ok, "C#7"}
      assert TritoneSubstitution.substitute("C dominant7") == {:ok, "F# dominant7"}
    end

    test "validates complete tritone substitution cycle" do
      # Test that going around the circle of fifths with tritone subs works
      substitution_pairs = [
        {"C7", "F#7"}, {"F#7", "C7"},
        {"G7", "C#7"}, {"C#7", "G7"},
        {"D7", "G#7"}, {"G#7", "D7"},
        {"A7", "D#7"}, {"D#7", "A7"},
        {"E7", "A#7"}, {"A#7", "E7"},
        {"B7", "F7"}, {"F7", "B7"}
      ]

      Enum.each(substitution_pairs, fn {original, expected} ->
        assert TritoneSubstitution.substitute(original) == {:ok, expected}
      end)
    end
  end
end
