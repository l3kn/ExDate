defmodule ExDate do
  alias ExDate.Tokeniser
  alias ExDate.Parser
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
    result = datestring
    |> String.upcase
    |> String.to_char_list
    |> Tokeniser.tokenise([])
    |> Parser.parse(now)
    |> filter_hints

    case result do
      {date, time, _ms} -> {date, time}
      {:error, reason} -> raise ArgumentError, message: reason
    end
  end

  def filter_hints({{yr, {:month, mon}, day}, {hr, min, sec}}) do
    filter_hints({{yr, mon, day}, {hr, min, sec}})
  end

  def filter_hints({{yr, {:month, mon}, day}, {hr, min, sec}, {ms}}) do
    filter_hints({{yr, mon, day}, {hr, min, sec}, {ms}})
  end

  def filter_hints(other), do: other
end
