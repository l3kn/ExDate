defmodule ExDate do
  alias ExDate.Tokeniser
  alias ExDate.Parser
  alias ExDate.Formatter

  alias :calendar, as: Cal

  def parse(datestring) do
    do_parse(datestring, Cal.universal_time)
  end

  def parse(datestring, {_,_,_} = now) do
    do_parse(datestring, Cal.now_to_datetime(now))
  end

  def parse(datestring, now) do
    do_parse(datestring, now)
  end

  def do_parse(datestring, now) do
    {date, time, _ms} = datestring
    |> String.upcase
    |> String.to_char_list
    |> Tokeniser.tokenise([])
    |> Parser.parse(now)
    |> filter_hints

    {date, time}
  end

  def to_iso(date) do
    Formatter.format(:iso, date)
    |> List.to_string
  end

  def filter_hints({{yr, {:month, mon}, day}, {hr, min, sec}}) do
    filter_hints({{yr, mon, day}, {hr, min, sec}})
  end

  def filter_hints({{yr, {:month, mon}, day}, {hr, min, sec}, {ms}}) do
    filter_hints({{yr, mon, day}, {hr, min, sec}, {ms}})
  end

  def filter_hints(other), do: other
end
