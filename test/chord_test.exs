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

  describe "new/2" do
    test "creates chord struct with valid root and quality" do
      chord = Chord.new("C", "major")
      assert %Chord{root: "C", quality: "major", notes: ["C", "E", "G"]} = chord
    end

    test "creates chord struct with abbreviations" do
      chord = Chord.new("F#", "m7")
      assert %Chord{root: "F#", quality: "m7", notes: ["F#", "A", "C#", "E"]} = chord
    end

    test "handles enharmonic equivalents in root" do
      chord = Chord.new("Db", "major")
      assert %Chord{root: "Db", quality: "major", notes: ["C#", "F", "G#"]} = chord
    end

    test "returns error for invalid root" do
      assert {:error, "Invalid chord format"} = Chord.new("H", "major")
    end

    test "returns error for invalid quality" do
      assert {:error, "Unknown chord quality: invalid"} = Chord.new("C", "invalid")
    end
  end

  describe "new/1" do
    test "creates chord struct from chord string" do
      chord = Chord.new("G major")
      assert %Chord{root: "G", quality: "major", notes: ["G", "B", "D"]} = chord
    end

    test "creates chord struct from abbreviated chord string" do
      chord = Chord.new("Am7")
      assert %Chord{root: "A", quality: "m7", notes: ["A", "C", "E", "G"]} = chord
    end

    test "handles chord string with spaces" do
      chord = Chord.new("Bb major7")
      assert %Chord{root: "Bb", quality: "major7", notes: ["A#", "D", "F", "A"]} = chord
    end

    test "returns error for invalid chord string format" do
      assert {:error, "Invalid chord format"} = Chord.new("notachord")
      assert {:error, "Invalid chord format"} = Chord.new("")
    end

    test "returns error for invalid root in chord string" do
      assert {:error, "Invalid chord format"} = Chord.new("H major")
    end
  end

  describe "notes_from_chord_array/1" do
    test "returns notes for array of chord strings" do
      chords = ["C major", "D minor", "G7"]
      result = Chord.notes_from_chord_array(chords)

      assert result == [
        {:ok, ["C", "E", "G"]},
        {:ok, ["D", "F", "A"]},
        {:ok, ["G", "B", "D", "F"]}
      ]
    end

    test "handles mixed valid and invalid chords" do
      chords = ["C major", "invalid", "Am"]
      result = Chord.notes_from_chord_array(chords)

      assert result == [
        {:ok, ["C", "E", "G"]},
        {:error, "Invalid chord format"},
        {:ok, ["A", "C", "E"]}
      ]
    end

    test "handles empty array" do
      result = Chord.notes_from_chord_array([])
      assert result == []
    end

    test "handles array with enharmonic equivalents" do
      chords = ["Db major", "E# minor"]
      result = Chord.notes_from_chord_array(chords)

      assert result == [
        {:ok, ["C#", "F", "G#"]},
        {:ok, ["F", "G#", "C"]}
      ]
    end
  end

  describe "all_chords/0" do
    test "returns a list of all possible chords" do
      all_chords = Chord.all_chords()

      assert is_list(all_chords)
      assert length(all_chords) > 0
    end

    test "includes basic major and minor chords for all roots" do
      all_chords = Chord.all_chords()
      chord_names = Enum.map(all_chords, fn {chord_name, _notes} ->
        Atom.to_string(chord_name)
      end)

      assert "C major" in chord_names
      assert "A minor" in chord_names
      assert "F# major" in chord_names
      assert "A# minor" in chord_names
    end

    test "includes extended chords" do
      all_chords = Chord.all_chords()
      chord_names = Enum.map(all_chords, fn {chord_name, _notes} ->
        Atom.to_string(chord_name)
      end)

      assert Enum.any?(chord_names, &String.contains?(&1, "major7"))
      assert Enum.any?(chord_names, &String.contains?(&1, "dominant7"))
      assert Enum.any?(chord_names, &String.contains?(&1, "diminished"))
    end

    test "each chord entry has correct format" do
      all_chords = Chord.all_chords()

      Enum.each(all_chords, fn {chord_name, notes} ->
        assert is_atom(chord_name)
        assert is_list(notes)
        assert Enum.all?(notes, &is_binary/1)
      end)
    end

    test "generates chords for all 12 chromatic notes" do
      all_chords = Chord.all_chords()
      chord_names = Enum.map(all_chords, fn {chord_name, _notes} ->
        Atom.to_string(chord_name)
      end)

      chromatic_notes = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]

      Enum.each(chromatic_notes, fn note ->
        assert Enum.any?(chord_names, &String.starts_with?(&1, note <> " "))
      end)
    end
  end

  describe "edge cases and error handling" do
    test "handles case sensitivity in pitch finding" do
      result = Chord.find_chords_with_pitches("ceg")
      assert result == []
    end

    test "handles malformed note strings gracefully" do
      result = Chord.find_chords_with_pitches("C E G X")
      assert is_list(result)
      assert "C major" in result
    end

    test "notes function handles internal whitespace" do
      assert Chord.notes("C  major") == {:ok, ["C", "E", "G"]}
      assert Chord.notes("C\tmajor") == {:ok, ["C", "E", "G"]}
    end

    test "find_chords_with_pitches handles repeated notes in different octaves" do
      result = Chord.find_chords_with_pitches(["C", "C", "E", "G"])
      assert "C major" in result
    end

    test "chord creation with empty quality defaults to major" do
      chord = Chord.new("C", "")
      assert %Chord{root: "C", quality: "", notes: ["C", "E", "G"]} = chord
    end

    test "handles enharmonic equivalents in find_chords_with_pitches" do
      result1 = Chord.find_chords_with_pitches("C# D# F#")
      result2 = Chord.find_chords_with_pitches("Db Eb Gb")
      assert length(result1) == length(result2)

      # Both should find the same chords since they represent the same pitches
      normalized_result1 = Enum.sort(result1)
      normalized_result2 = Enum.sort(result2)
      assert normalized_result1 == normalized_result2
    end

    test "handles invalid characters in chord quality gracefully" do
      assert {:error, _} = Chord.notes("C invalidquality123")
    end
  end
end
