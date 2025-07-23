defmodule ChordSubstituter.Chord do
  alias ChordSubstituter.Chord
  alias ChordSubstituter.ChordData
  alias ChordSubstituter.MusicTheory

  @type t :: %__MODULE__{
    root: String.t() | nil,
    quality: String.t() | nil,
    notes: [String.t()] | nil
  }

  defstruct root: nil, quality: nil, notes: nil

  @spec new(String.t(), String.t()) :: {:ok, t()} | {:error, String.t()}
  def new(root, quality) do
    "#{root} #{quality}"
    |> notes()
    |> create_chord_struct(root, quality)
  end

  @spec new(String.t()) :: {:ok, t()} | {:error, String.t()}
  def new(chord_string) do
    with {:ok, {root, quality}} <- parse_root_and_quality(chord_string) do
      new(root, quality)
    end
  end

  @doc """
  Returns the notes of a chord given a chord string (e.g., "C major", "D minor").
  """
  @spec notes(String.t()) :: {:ok, [String.t()]} | {:error, String.t()}
  def notes(chord_string) do
    chord_string
    |> parse_root_and_quality()
    |> extract_intervals_and_build_notes()
  end

  def notes_from_chord_array(chord_array) do
    Enum.map(chord_array, fn chord -> notes(chord) end)
  end

  @doc """
  Finds all chords that contain the given pitches.

  Accepts either a string of pitches (e.g., "CEG") or a list of pitch strings (e.g., ["C", "E", "G"]).
  Returns a list of chord strings that contain all the given pitches.

  Examples:
    find_chords_with_pitches("CEG") -> ["C major", "C major7", "A minor7"]
    find_chords_with_pitches(["C", "E#", "A", "E"]) -> ["F major7"]
  """
  @pitch_match_defaults %{match_exact: false}
  def find_chords_with_pitches(pitches, options \\ [])
  def find_chords_with_pitches(pitches, options) when is_binary(pitches) do
    pitches
    |> parse_notes_from_string()
    |> find_chords_with_pitches(options)
  end

  def find_chords_with_pitches(pitches, options) when is_list(pitches) do
    %{match_exact: match_exact?} = Enum.into(options, @pitch_match_defaults)
    requisite_pitch_count = if match_exact?, do: 3, else: 2

    normalized_pitches = Enum.map(pitches, &MusicTheory.get_enharmonic_equivalent/1)

    unique_pitches = Enum.uniq(normalized_pitches)

    if length(unique_pitches) < requisite_pitch_count do
      {:error, "Insufficient unique pitches to match against."}
    else
      chords_matching_pitches(unique_pitches, match_exact?)
    end
  end

  @spec all_chords() :: [{String.t(), [String.t()]}]
  def all_chords do
    for root <- MusicTheory.note_names(),
        {quality, intervals} <- ChordData.interval_map(),
        {:ok, notes} <- [build_notes(root, intervals)] do
      {"#{root} #{quality}", notes}
    end
  end

  @spec normalize_quality(String.t()) :: String.t()
  def normalize_quality(quality), do: quality |> String.downcase() |> String.trim()

  @spec get_intervals(String.t()) :: {:ok, [integer()]} | {:error, String.t()}
  defp get_intervals(quality) do
    quality
    |> normalize_quality()
    |> ChordData.expand_quality_abbreviation()
    |> ChordData.get_intervals()
  end

  @spec build_notes(String.t(), [integer()]) :: {:ok, [String.t()]} | {:error, String.t()}
  defp build_notes(root, intervals) do
    root
    |> MusicTheory.note_index()
    |> build_chord_notes(intervals)
  end

  @spec parse_root_and_quality(String.t()) :: {:ok, {String.t(), String.t()}} | {:error, String.t()}
  defp parse_root_and_quality(string) do
    string
    |> capture_chord_quality()
    |> validate_parsed_chord()
  end

  @spec parse_notes_from_string(String.t()) :: [String.t()]
  defp parse_notes_from_string(notes_string) do
    notes_string
    |> capture_notes()
    |> List.flatten()
  end

  @spec capture_notes(String.t()) :: [[String.t()]]
  defp capture_notes(notes_string), do: Regex.scan(~r/([A-G][b#]?)/, notes_string, capture: :first)

  @spec capture_chord_quality(String.t()) :: %{String.t() => String.t()} | nil
  defp capture_chord_quality(chord_string), do: Regex.named_captures(~r/^(?<root>[A-G][b#]?)(?<quality>.*)$/, chord_string)

  @spec chords_matching_pitches([String.t()], boolean()) :: [String.t()]
  defp chords_matching_pitches(pitches, match_exact?) do
    match_function = if match_exact?, do: &pitches_match_exactly?/2, else: &pitches_matching?/2
    find_matching_chords_recursive(all_chords(), pitches, match_function, [])
  end

  @spec pitches_matching?([String.t()], [String.t()]) :: boolean()
  defp pitches_matching?(input_pitches, chord_notes), do: Enum.all?(input_pitches, &Enum.member?(chord_notes, &1))

  @spec pitches_match_exactly?([String.t()], [String.t()]) :: boolean()
  defp pitches_match_exactly?(chord_notes, input_pitches) do
    length(chord_notes) == length(input_pitches) and pitches_matching?(input_pitches, chord_notes)
  end

  @spec create_chord_struct({:ok, [String.t()]} | {:error, String.t()}, String.t(), String.t()) :: {:ok, t()} | {:error, String.t()}
  defp create_chord_struct({:ok, notes}, root, quality), do: {:ok, %Chord{root: root, quality: quality, notes: notes}}
  defp create_chord_struct({:error, reason}, _root, _quality), do: {:error, reason}

  @spec extract_intervals_and_build_notes({:ok, {String.t(), String.t()}} | {:error, String.t()}) :: {:ok, [String.t()]} | {:error, String.t()}
  defp extract_intervals_and_build_notes({:ok, {root, quality}}) do
    quality
    |> get_intervals()
    |> build_notes_from_intervals(root)
  end
  defp extract_intervals_and_build_notes({:error, reason}), do: {:error, reason}

  @spec build_notes_from_intervals({:ok, [integer()]} | {:error, String.t()}, String.t()) :: {:ok, [String.t()]} | {:error, String.t()}
  defp build_notes_from_intervals({:ok, intervals}, root), do: build_notes(root, intervals)
  defp build_notes_from_intervals({:error, reason}, _root), do: {:error, reason}


  @spec build_chord_notes(integer() | nil, [integer()]) :: {:ok, [String.t()]} | {:error, String.t()}
  defp build_chord_notes(nil, _intervals), do: {:error, "Unknown root note"}
  defp build_chord_notes(root_index, intervals) do
    notes = build_notes_recursive(intervals, root_index, [])
    {:ok, notes}
  end

  @spec build_notes_recursive([integer()], integer(), [String.t()]) :: [String.t()]
  defp build_notes_recursive([], _root_index, acc), do: Enum.reverse(acc)
  defp build_notes_recursive([interval | rest], root_index, acc) do
    note = calculate_note_at_interval(root_index, interval)
    build_notes_recursive(rest, root_index, [note | acc])
  end

  @spec calculate_note_at_interval(integer(), integer()) :: String.t()
  defp calculate_note_at_interval(root_index, interval) do
    note_names = MusicTheory.note_names()
    target_index = rem(root_index + interval, length(note_names))
    Enum.at(note_names, target_index)
  end

  @spec validate_parsed_chord(%{String.t() => String.t()} | nil) :: {:ok, {String.t(), String.t()}} | {:error, String.t()}
  defp validate_parsed_chord(nil), do: {:error, "Invalid chord format"}
  defp validate_parsed_chord(%{"quality" => quality, "root" => root}) do
    if MusicTheory.valid_note?(root) do
      {:ok, {root, String.trim(quality)}}
    else
       {:error, "Unknown root note: #{root}"}
    end
  end

  @spec find_matching_chords_recursive([{String.t(), [String.t()]}], [String.t()], function(), [String.t()]) :: [String.t()]
  defp find_matching_chords_recursive([], _pitches, _match_function, acc), do: Enum.reverse(acc)
  defp find_matching_chords_recursive([{name, notes} | rest], pitches, match_function, acc) do
    new_acc = if match_function.(pitches, notes), do: [name | acc], else: acc
    find_matching_chords_recursive(rest, pitches, match_function, new_acc)
  end
end
