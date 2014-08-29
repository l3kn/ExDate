ExDate
======

ExDate is an Elixir implementation of the universal Date/Time parser [ec_date](https://github.com/erlware/erlware_commons/blob/master/src/ec_date.erl).

Currently it only the parser (String -> `{{Year, Month, Day}, {Hour, Minute, Second}}`) is implemented.

## Current Status

[![Build Status](https://travis-ci.org/l3kn/ExDate.png?branch=master)](https://travis-ci.org/l3kn/ExDate)

## Usage

Add ExDate as a dependeny in your `mix.exs` file.

``` elixir
defp deps do
  [{:ex_date, github: "l3kn/ExDate"}]
end
```

And run `mix deps.get` in your shell to fetch the dependencies.

``` elixir
iex> ExDate."Sat 22nd of August 2008")
{{2008,8,22},{17,16,17}}
# {{year, month, day}, {hour, minute, second}}
```

## Supported formats

* ISO 8601
* RFC 1123
* Gregorian, day-month-year
* Gregorian, year-month-day
* Gregorian, month-day-year
* Times (hh:mm:ss, hh:mm, hh)

### Examples

``` elixir
  "22nd of August 2008"
  "22-Aug-2008 6 AM"
  "August/22/2008 6:35 AM"
  "22 August 2008 6:35 AM"
  "22 Aug 2008 6:35 AM"
  "August 22nd, 2008, 6:15:15pm"
  "Aug 22nd 2008, 18:15"
  "2nd of August 2008"
  "August 2nd, 2008"
  "2nd  August, 2008"
  "2008 August 2nd"
  "2-Aug-2008 6:35:12 AM"
  "2 August 2008 6:35 AM"
  "2 Aug 2008 6:35 AM"
  "2 Aug 2008 6 PM"
  "Aug 2, 2008 6 PM"
  "August 2nd, 2008 6:00 PM"
  "Dec 10th, 2012, 12:00 AM"
  "10 Dec 2012 12:00 AM"
  "23-4-1963"
  "11:15"
  "1:15"
  "1:15 am"
  "12:15 am"
  "12:15 pm"
  "3:45:39"
  "Monday 22 Aug 2008 6"
  "Monday 22 Aug 2008 6p"
  "Monday 22 Aug 2008 6a"
  "Mon, 22 Aug 2008 6:35 PM"
```

See `test/ex_date_test.exs` for more.

### TODO

* Support structs as alternative to erlang dates
* Handle overflows like `23:00+10`
* Add support for timezones
* Implement the formater

## Credits

* [erlware_commons](https://github.com/erlware/erlware_commons)
* [dh_date](https://github.com/daleharvey/dh_date)
