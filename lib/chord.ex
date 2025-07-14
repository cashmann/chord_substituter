defmodule ChordSubstituter.Chord do
  alias ChordSubstituter.Chord
  alias ChordSubstituter.ChordData

  defstruct root: nil, quality: nil, notes: nil

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

  def new(root, quality) do
    %Chord{root: root, quality: quality}
  end

  def from_string(string) do
    case parse_root_and_quality(string) do
      {root, ""} ->
        {:ok, new(root, "major")}

      {root, quality} ->
        {:ok, new(root, quality)}

      :error ->
        {:error, "Invalid chord format"}
    end
  end

  @doc """
  Returns the notes of a chord given a chord string (e.g., "C major", "D minor").
  """
  def notes(chord_string) do
    with {:ok, chord} <- from_string(chord_string),
         {:ok, intervals} <- get_intervals(chord.quality),
         {:ok, notes} <- build_notes(chord.root, intervals) do
      {:ok, notes}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def notes_from_chord_array(chord_array) do
    Enum.map(chord_array, fn chord -> notes(chord) end)
  end

  defp get_intervals(quality) do
    quality = String.downcase(quality) |> String.trim()

    full_quality = ChordData.expand_quality_abbreviation(quality)

    ChordData.get_intervals(full_quality)
  end


  defp note_index(note) when is_binary(note) do
    normalized_note = Map.get(@enharmonic_equivalents, note, note)
    Enum.find_index(@note_names, &(&1 == normalized_note))
  end

  defp build_notes(root, intervals) do
    case note_index(root) do
      nil ->
        {:error, "Unknown root note: #{root}"}

      root_index ->
        notes =
          Enum.map(intervals, fn interval ->
            Enum.at(@note_names, rem(root_index + interval, length(@note_names)))
          end)

        {:ok, notes}
    end
  end

  defp parse_root_and_quality(string) do
    case capture_chord_quality(string) do
      %{"quality" => quality, "root" => root} ->
        if is_valid_root?(root) do
          {root, String.trim(quality)}
        else
          :error
        end

      _ ->
        :error
    end
  end

  defp is_valid_root?(root),
    do: Enum.member?(@note_names, root) or Map.has_key?(@enharmonic_equivalents, root)

  defp parse_notes_from_string(notes_string) do
    notes_string
    |> capture_notes()
    |> List.flatten()
  end

  defp capture_notes(notes_string), do: Regex.scan(~r/([A-G][b#]?)/, notes_string, capture: :first)

  defp capture_chord_quality(chord_string), do: Regex.named_captures(~r/^(?<root>[A-G][b#]?)(?<quality>.*)$/, chord_string)

  @doc """
  Finds all chords that contain the given pitches.

  Accepts either a string of pitches (e.g., "CEG") or a list of pitch strings (e.g., ["C", "E", "G"]).
  Returns a list of chord strings that contain all the given pitches.

  Examples:
    find_chords_with_pitches("CEG") -> ["C major", "C major7", "A minor7"]
    find_chords_with_pitches(["C", "E#", "A", "E"]) -> ["F major7"]
  """
  def find_chords_with_pitches(pitches) when is_binary(pitches) do
    pitches
    |> parse_notes_from_string()
    |> find_chords_with_pitches()
  end

  def find_chords_with_pitches(pitches) when is_list(pitches) do
    normalized_pitches = Enum.map(pitches, &normalize_pitch/1)

    unique_pitches = Enum.uniq(normalized_pitches)

    if length(unique_pitches) < 2 do
      []
    else
      chords_matching_pitches(unique_pitches)
    end
  end

  defp chords_matching_pitches(pitches) do
    Enum.map(all_chords(), fn {name, notes} ->
      if Enum.all?(pitches, &Enum.member?(notes, &1)), do: Atom.to_string(name)
    end)
    |> Enum.reject(&is_nil(&1))
  end

  def all_chords do
    Enum.flat_map(@note_names, fn root ->
      Enum.flat_map(ChordData.interval_map(), fn {quality, intervals} ->
        {_, notes} = build_notes(root, intervals)

        %{"#{root} #{quality}": notes}
      end)
    end)
  end

  defp normalize_pitch(pitch) do
    Map.get(@enharmonic_equivalents, pitch, pitch)
  end
end
