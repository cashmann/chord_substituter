defmodule ChordSubstituter.ChordTest do
  use ExUnit.Case, async: true
  alias ChordSubstituter.Chord

  describe "notes/1" do
    test "parses and returns notes for major chords (spaced and unspaced)" do
      assert Chord.notes("C major") == {:ok, ["C", "E", "G"]}
      assert Chord.notes("Cmaj") == {:ok, ["C", "E", "G"]}
      assert Chord.notes("C") == {:ok, ["C", "E", "G"]}
    end

    test "parses and returns notes for minor chords (spaced and unspaced)" do
      assert Chord.notes("A minor") == {:ok, ["A", "C", "E"]}
      assert Chord.notes("Amin") == {:ok, ["A", "C", "E"]}
      assert Chord.notes("A m") == {:ok, ["A", "C", "E"]}
    end

    test "handles accidentals and enharmonic equivalents" do
      assert Chord.notes("Bb min") == {:ok, ["A#", "C#", "F"]}
      assert Chord.notes("Db major") == {:ok, ["C#", "F", "G#"]}
      assert Chord.notes("E# maj") == {:ok, ["F", "A", "C"]}
    end

    test "handles seventh chords and abbreviations" do
      assert Chord.notes("G7") == {:ok, ["G", "B", "D", "F"]}
      assert Chord.notes("F#maj7") == {:ok, ["F#", "A#", "C#", "F"]}
      assert Chord.notes("Bdim7") == {:ok, ["B", "D", "F", "G#"]}
    end

    test "returns error for invalid chord format" do
      assert Chord.notes("notachord") == {:error, "Invalid chord format"}
      assert Chord.notes("") == {:error, "Invalid chord format"}
    end

    test "returns error for unknown root or quality" do
      assert Chord.notes("H major") == {:error, "Invalid chord format"}
      assert Chord.notes("C unknown") == {:error, "Unknown chord quality: unknown"}
    end
  end

  describe "from_string/1" do
    test "parses root and quality correctly" do
      assert Chord.from_string("Cmaj7") == {:ok, %Chord{root: "C", quality: "maj7"}}
      assert Chord.from_string("Bb min") == {:ok, %Chord{root: "Bb", quality: "min"}}
      assert Chord.from_string("F#") == {:ok, %Chord{root: "F#", quality: "major"}}
    end

    test "returns error for invalid input" do
      assert Chord.from_string("badinput") == {:error, "Invalid chord format"}
    end
  end

  describe "find_chords_with_pitches/1" do
    test "finds chords from string input" do
      result = Chord.find_chords_with_pitches("CEG")
      assert "C major" in result
      assert "C major7" in result
      assert "A minor7" in result
    end

    test "finds chords from list input" do
      result = Chord.find_chords_with_pitches(["C", "E#", "A", "E"])
      assert "F major7" in result
    end

    test "handles enharmonic equivalents" do
      result = Chord.find_chords_with_pitches("Bb C# E Ab")
      assert "A# half_diminished7" in result
    end

    test "handles single pitch input" do
      result = Chord.find_chords_with_pitches("C")
      assert result == []
    end

    test "handles empty input" do
      result = Chord.find_chords_with_pitches([])
      assert result == []
    end

    test "handles duplicate pitches" do
      result = Chord.find_chords_with_pitches(["C", "E", "G", "C"])
      assert "C major" in result
      assert "C major7" in result
    end

    test "finds multiple chord types for same pitches" do
      result = Chord.find_chords_with_pitches("C E G")
      assert "C major" in result
      assert "C major7" in result
      assert "A minor7" in result
    end

    test "finds C major7 from CEGB" do
      result = Chord.find_chords_with_pitches("CEGB")
      assert "C major7" in result
    end

    test "finds C dominant7 from CEGBb" do
      result = Chord.find_chords_with_pitches("CEGBb")
      assert "C dominant7" in result
    end
  end
end
