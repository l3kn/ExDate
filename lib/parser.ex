defmodule ExDate.Parser do
  # Helper guards and functions

  defmacro meridian?(x) do
    quote do
      unquote(x) == [] or
      unquote(x) == [:am] or
      unquote(x) == [:pm]
    end
  end

  defmacro year?(x) do
    quote do is_integer(unquote(x)) and unquote(x) > 31 end
  end

  defmacro is_day?(x) do
    quote do is_integer(unquote(x)) and unquote(x) <= 31 end
  end

  defmacro hinted_month?(x) do
    quote do
      is_tuple(unquote(x)) and
      tuple_size(unquote(x)) == 2 and
      elem(unquote(x), 0) == :month
    end
  end

  defmacro us_sep?(x) do
    quote do unquote(x) == '/' end
  end

  defmacro world_sep?(x) do
    quote do unquote(x) == '-' end
  end

  defmacro any_sep?(x) do
    quote do unquote(x) == '/' or unquote(x) == '-' end
  end

  def hour(h, []), do: h
  def hour(12, [:am]), do: 0;
  def hour(h, [:am]), do: h
  def hour(12, [:pm]), do: 12;
  def hour(h, [:pm]), do: h + 12

  # ISO 8601 like dates
  # * 2014-08-24T22:23:00Z
  # * 2014-08-24T22:23:00+02
  # * 2014-08-24T22:23:00-02
  # * etc.

  # hh:mm:ss
  def parse([yr, s, mon, s, day, hr, ':', min, ':', sec, 'Z'], _n)
  when any_sep?(s) and year?(yr) do
    {{yr, mon, day}, {hr, min, sec}, {0}}
  end

  def parse([yr, s, mon, s, day, hr, ':', min, ':', sec, '+', off | _rest], _n)
  when any_sep?(s) and year?(yr) do
    {{yr, mon, day}, {hr - off, min, sec}, {0}}
  end

  def parse([yr, s, mon, s, day, hr, ':', min, ':', sec, '-', off | _rest], _n)
  when any_sep?(s) and year?(yr) do
    {{yr, mon, day}, {hr + off, min, sec}, {0}}
  end

  # hh:mm

  def parse([yr, s, mon, s, day, hr, ':', min, 'Z'], _n)
  when any_sep?(s) and year?(yr) do
    {{yr, mon, day}, {hr, min, 0}, {0}}
  end

  def parse([yr, s, mon, s, day, hr, ':', min, '+', off | _rest], _n)
  when any_sep?(s) and year?(yr) do
    {{yr, mon, day}, {hr - off, min, 0}, {0}}
  end

  def parse([yr, s, mon, s, day, hr, ':', min, '-', off | _rest], _n)
  when any_sep?(s) and year?(yr) do
    {{yr, mon, day}, {hr + off, min, 0}, {0}}
  end

  # Date/Times 
  # * 2014-Aug-28 10:48:35.0001 AM
  # * 28 Aug 2014 10:48:35.0001 PM
  # * Aug/28/2014 10:48:35.0001
  # * etc.
  #TODO: Check/Implement line 169-178 of https://github.com/erlware/erlware_commons/blob/master/src/ec_date.erl

  def parse([yr, s, mon, s, day, hr, ':', min, ':', sec, '.', ms | med], _n)
  when any_sep?(s) and year?(yr) and meridian?(med) do
    {{yr, mon, day}, {hour(hr, med), min, sec}, {ms}}
  end

  def parse([mon, s, day, s, yr, hr, ':', min, ':', sec, '.', ms | med], _n)
  when us_sep?(s) and year?(yr) and meridian?(med) do
    {{yr, mon, day}, {hour(hr, med), min, sec}, {ms}}
  end

  def parse([day, s, mon, s, yr, hr, ':', min, ':', sec, '.', ms | med], _n)
  when world_sep?(s) and year?(yr) and meridian?(med) do
    {{yr, mon, day}, {hour(hr, med), min, sec}, {ms}}
  end

  # Date/Times
  # * Dec 1st, 2012 6:25 PM
  # * Dec 1st, 2012 18:25:15
  # * etc.

  def parse([mon, day, yr, hr, ':', min, ':', sec | med], _n)
  when meridian?(med) and hinted_month?(mon) and is_day?(day) do
    {{yr, mon, day}, {hour(hr, med), min, sec}, {0}}
  end

  def parse([mon, day, yr, hr, ':', min | med], _n)
  when meridian?(med) and hinted_month?(mon) and is_day?(day) do
    {{yr, mon, day}, {hour(hr, med), min, 0}, {0}}
  end

  def parse([mon, day, yr, hr | med], _n)
  when meridian?(med) and hinted_month?(mon) and is_day?(day) do
    {{yr, mon, day}, {hour(hr, med), 0, 0}, {0}}
  end

  # Times
  # * 21:45
  # * 13:45:54
  # * 1:45PM
  # * 1 PM
  # * etc.

  def parse([hr, ':', min, ':', sec | med], {date, _time})
  when meridian?(med) do
    {date, {hour(hr, med), min, sec}, {0}}
  end

  def parse([hr, ':', min | med], {date, _time})
  when meridian?(med) do
    {date, {hour(hr, med), min, 0}, {0}}
  end

  def parse([hr | med], {date, _time})
  when meridian?(med) do
    {date, {hour(hr, med), 0, 0}, {0}}
  end

  # Dates Any combination with word month
  # * aug 8th, 2008
  # * 8 aug 2008
  # * 2008 aug 21
  # * 2008 5 aug

  def parse([day, mon, yr], {_date, time})
  when is_day?(day) and hinted_month?(mon) and year?(yr) do
    {{yr, mon, day}, time, {0}}
  end

  def parse([mon, day, yr], {_date, time})
  when is_day?(day) and hinted_month?(mon) and year?(yr) do
    {{yr, mon, day}, time, {0}}
  end

  def parse([yr, day, mon], {_date, time})
  when is_day?(day) and hinted_month?(mon) and year?(yr) do
    {{yr, mon, day}, time, {0}}
  end

  def parse([yr, mon, day], {_date, time})
  when is_day?(day) and hinted_month?(mon) and year?(yr) do
    {{yr, mon, day}, time, {0}}
  end

  # Dates Speparated combinations with word month
  # * 23/april/1999
  # * 1999/april/23
  # * 23-april-1999

  def parse([yr, sep, mon, sep, day], {_date, time})
  when any_sep?(sep) and year?(yr) do
    {{yr, mon, day}, time, {0}}
  end

  def parse([mon, sep, day, sep, yr], {_date, time})
  when us_sep?(sep) and year?(yr) do
    {{yr, mon, day}, time, {0}}
  end

  def parse([day, sep, mon, sep, yr], {_date, time})
  when world_sep?(sep) and year?(yr) do
    {{yr, mon, day}, time, {0}}
  end

  # Date/Times Speparated combinations with word month
  # * 23/april/1999 6 PM
  # * 23/april/1999 6:25 PM
  # * 23/april/1999 6:25:30 PM

  # Hours only
  def parse([yr, sep, mon, sep, day, hr | med], _n)
  when meridian?(med) and any_sep?(sep) and year?(yr) do
    {{yr, mon, day}, {hour(hr, med), 0, 0}, {0}}
  end

  def parse([mon, sep, day, sep, yr, hr | med], _n)
  when meridian?(med) and us_sep?(sep) and year?(yr) do
    {{yr, mon, day}, {hour(hr, med), 0, 0}, {0}}
  end

  def parse([day, sep, mon, sep, yr, hr | med], _n)
  when meridian?(med) and world_sep?(sep) and year?(yr) do
    {{yr, mon, day}, {hour(hr, med), 0, 0}, {0}}
  end

  # Hours and minutes
  def parse([yr, sep, mon, sep, day, hr, ':', min | med], _n)
  when meridian?(med) and any_sep?(sep) and year?(yr) do
    {{yr, mon, day}, {hour(hr, med), min, 0}, {0}}
  end

  def parse([mon, sep, day, sep, yr, hr, ':', min | med], _n)
  when meridian?(med) and us_sep?(sep) and year?(yr) do
    {{yr, mon, day}, {hour(hr, med), min, 0}, {0}}
  end

  def parse([day, sep, mon, sep, yr, hr, ':', min | med], _n)
  when meridian?(med) and world_sep?(sep) and year?(yr) do
    {{yr, mon, day}, {hour(hr, med), min, 0}, {0}}
  end

  # Hours, minutes and seconds
  def parse([yr, sep, mon, sep, day, hr, ':', min, ':', sec | med], _n)
  when meridian?(med) and any_sep?(sep) and year?(yr) do
    {{yr, mon, day}, {hour(hr, med), min, sec}, {0}}
  end

  def parse([mon, sep, day, sep, yr, hr, ':', min, ':', sec | med], _n)
  when meridian?(med) and us_sep?(sep) and year?(yr) do
    {{yr, mon, day}, {hour(hr, med), min, sec}, {0}}
  end

  def parse([day, sep, mon, sep, yr, hr, ':', min, ':', sec | med], _n)
  when meridian?(med) and world_sep?(sep) and year?(yr) do
    {{yr, mon, day}, {hour(hr, med), min, sec}, {0}}
  end

  # Datetimes seperated with spaces
  # * 1. 4. 2014, 1pm
  # * 1 4 2014 13:10
  # * 1 4 2014 1:10:46am

  def parse([day, mon, yr, hr | med], _n)
  when meridian?(med) do
    {{yr, mon, day}, {hour(hr, med), 0, 0}, {0}}
  end

  def parse([day, mon, yr, hr, ':', min | med], _n)
  when meridian?(med) do
    {{yr, mon, day}, {hour(hr, med), min, 0}, {0}}
  end

  def parse([day, mon, yr, hr, ':', min, ':', sec | med], _n)
  when meridian?(med) do
    {{yr, mon, day}, {hour(hr, med), min, sec}, {0}}
  end

  def parse(_, now) do
    {:error, :bad_date}
  end
end
