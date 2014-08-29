defmodule ExDateTest do
  use ExUnit.Case
  import ExDate

  @date {{2001,3,10}, {17,16,17}}

  test "Basic parser" do
    assert {{2008,8,22}, {17,16,17}} ==
           parse("22nd of August 2008", @date)
    assert {{2008,8,22}, {6,0,0}} ==
           parse("22-Aug-2008 6 AM", @date)
    assert {{2008,8,22}, {6,35,0}} ==
           parse("22-Aug-2008 6:35 AM", @date)
    assert {{2008,8,22}, {6,35,12}} ==
           parse("22-Aug-2008 6:35:12 AM", @date)
    assert {{2008,8,22}, {6,0,0}} ==
           parse("August/22/2008 6 AM", @date)
    assert {{2008,8,22}, {6,35,0}} ==
           parse("August/22/2008 6:35 AM", @date)
    assert {{2008,8,22}, {6,35,0}} ==
           parse("22 August 2008 6:35 AM", @date)
    assert {{2008,8,22}, {6,0,0}} ==
           parse("22 Aug 2008 6AM", @date)
    assert {{2008,8,22}, {6,35,0}} ==
           parse("22 Aug 2008 6:35AM", @date)
    assert {{2008,8,22}, {6,35,0}} ==
           parse("22 Aug 2008 6:35 AM", @date)
    assert {{2008,8,22}, {6,0,0}} ==
           parse("22 Aug 2008 6", @date)
    assert {{2008,8,22}, {6,35,0}} ==
           parse("22 Aug 2008 6:35", @date)
    assert {{2008,8,22}, {18,35,0}} ==
           parse("22 Aug 2008 6:35 PM", @date)
    assert {{2008,8,22}, {18,0,0}} ==
           parse("22 Aug 2008 6 PM", @date)
    assert {{2008,8,22}, {18,0,0}} ==
           parse("Aug 22, 2008 6 PM", @date)
    assert {{2008,8,22}, {18,0,0}} ==
           parse("August 22nd, 2008 6:00 PM", @date)
    assert {{2008,8,22}, {18,15,15}} ==
           parse("August 22nd 2008, 6:15:15pm", @date)
    assert {{2008,8,22}, {18,15,15}} ==
           parse("August 22nd, 2008, 6:15:15pm", @date)
    assert {{2008,8,22}, {18,15,0}} ==
           parse("Aug 22nd 2008, 18:15", @date)
    assert {{2008,8,2}, {17,16,17}} ==
           parse("2nd of August 2008", @date)
    assert {{2008,8,2}, {17,16,17}} ==
           parse("August 2nd, 2008", @date)
    assert {{2008,8,2}, {17,16,17}} ==
           parse("2nd  August, 2008", @date)
    assert {{2008,8,2}, {17,16,17}} ==
           parse("2008 August 2nd", @date)
    assert {{2008,8,2}, {6,0,0}} ==
           parse("2-Aug-2008 6 AM", @date)
    assert {{2008,8,2}, {6,35,0}} ==
           parse("2-Aug-2008 6:35 AM", @date)
    assert {{2008,8,2}, {6,35,12}} ==
           parse("2-Aug-2008 6:35:12 AM", @date)
    assert {{2008,8,2}, {6,0,0}} ==
           parse("August/2/2008 6 AM", @date)
    assert {{2008,8,2}, {6,35,0}} ==
           parse("August/2/2008 6:35 AM", @date)
    assert {{2008,8,2}, {6,35,0}} ==
           parse("2 August 2008 6:35 AM", @date)
    assert {{2008,8,2}, {6,0,0}} ==
           parse("2 Aug 2008 6AM", @date)
    assert {{2008,8,2}, {6,35,0}} ==
           parse("2 Aug 2008 6:35AM", @date)
    assert {{2008,8,2}, {6,35,0}} ==
           parse("2 Aug 2008 6:35 AM", @date)
    assert {{2008,8,2}, {6,0,0}} ==
           parse("2 Aug 2008 6", @date)
    assert {{2008,8,2}, {6,35,0}} ==
           parse("2 Aug 2008 6:35", @date)
    assert {{2008,8,2}, {18,35,0}} ==
           parse("2 Aug 2008 6:35 PM", @date)
    assert {{2008,8,2}, {18,0,0}} ==
           parse("2 Aug 2008 6 PM", @date)
    assert {{2008,8,2}, {18,0,0}} ==
           parse("Aug 2, 2008 6 PM", @date)
    assert {{2008,8,2}, {18,0,0}} ==
           parse("August 2nd, 2008 6:00 PM", @date)
    assert {{2008,8,2}, {18,15,15}} ==
           parse("August 2nd 2008, 6:15:15pm", @date)
    assert {{2008,8,2}, {18,15,15}} ==
           parse("August 2nd, 2008, 6:15:15pm", @date)
    assert {{2008,8,2}, {18,15,0}} ==
           parse("Aug 2nd 2008, 18:15", @date)
    assert {{2012,12,10}, {0,0,0}} ==
           parse("Dec 10th, 2012, 12:00 AM", @date)
    assert {{2012,12,10}, {0,0,0}} ==
           parse("10 Dec 2012 12:00 AM", @date)
    assert {{2001,3,10}, {11,15,0}} ==
           parse("11:15", @date)
    assert {{2001,3,10}, {1,15,0}} ==
           parse("1:15", @date)
    assert {{2001,3,10}, {1,15,0}} ==
           parse("1:15 am", @date)
    assert {{2001,3,10}, {0,15,0}} ==
           parse("12:15 am", @date)
    assert {{2001,3,10}, {12,15,0}} ==
           parse("12:15 pm", @date)
    assert {{2001,3,10}, {3,45,39}} ==
           parse("3:45:39", @date)
    assert {{1963,4,23}, {17,16,17}} ==
           parse("23-4-1963", @date)
    assert {{1963,4,23}, {17,16,17}} ==
           parse("23-april-1963", @date)
    assert {{1963,4,23}, {17,16,17}} ==
           parse("23-apr-1963", @date)
    assert {{1963,4,23}, {17,16,17}} ==
           parse("4/23/1963", @date)
    assert {{1963,4,23}, {17,16,17}} ==
           parse("april/23/1963", @date)
    assert {{1963,4,23}, {17,16,17}} ==
           parse("apr/23/1963", @date)
    assert {{1963,4,23}, {17,16,17}} ==
           parse("1963/4/23", @date)
    assert {{1963,4,23}, {17,16,17}} ==
           parse("1963/april/23", @date)
    assert {{1963,4,23}, {17,16,17}} ==
           parse("1963/apr/23", @date)
    assert {{1963,4,23}, {17,16,17}} ==
           parse("1963-4-23", @date)
    assert {{1963,4,23}, {17,16,17}} ==
           parse("1963-4-23", @date)
    assert {{1963,4,23}, {17,16,17}} ==
           parse("1963-apr-23", @date)
    assert {{2001,3,10}, {6,45,0}} ==
           parse("6:45 am", @date)
    assert {{2001,3,10}, {18,45,0}} ==
           parse("6:45 PM", @date)
    assert {{2001,3,10}, {18,45,0}} ==
           parse("6:45 PM ", @date)
  end

  test "Parse with days" do
     assert {{2008,8,22},{17,16,17}} ==
            parse("Sat 22nd of August 2008", @date)
     assert {{2008,8,22},{6,35,0}} ==
            parse("Sat, 22-Aug-2008 6:35 AM", @date)
     assert {{2008,8,22},{6,35,12}} ==
            parse("Sunday 22-Aug-2008 6:35:12 AM", @date)
     assert {{2008,8,22},{6,35,0}} ==
            parse("Sun 22-Aug-2008 6:35 AM", @date)
     assert {{2008,8,22},{6,35,0}} ==
            parse("THURSDAY, 22-August-2008 6:35 AM", @date)
     assert {{2008,8,22},{18,0,0}} ==
            parse("THURSDAY, 22-August-2008 6 pM", @date)
     assert {{2008,8,22},{6,35,0}} ==
            parse("THU 22 August 2008 6:35 AM", @date)
     assert {{2008,8,22},{6,35,0}} ==
            parse("FRi 22 Aug 2008 6:35AM", @date)
     assert {{2008,8,22},{6,0,0}} ==
            parse("FRi 22 Aug 2008 6AM", @date)
     assert {{2008,8,22},{6,35,0}} ==
            parse("Wednesday 22 Aug 2008 6:35 AM", @date)
     assert {{2008,8,22},{6,35,0}} ==
            parse("Monday 22 Aug 2008 6:35", @date)
     assert {{2008,8,22},{6,0,0}} ==
            parse("Monday 22 Aug 2008 6", @date)
     assert {{2008,8,22},{18,0,0}} ==
            parse("Monday 22 Aug 2008 6p", @date)
     assert {{2008,8,22},{6,0,0}} ==
            parse("Monday 22 Aug 2008 6a", @date)
     assert {{2008,8,22},{18,35,0}} ==
            parse("Mon, 22 Aug 2008 6:35 PM", @date)
  end

  test "Parse with timezone" do
     assert {{2008,8,22}, {17,16,17}} ==
            parse("Sat 22nd of August 2008 GMT", @date)
     assert {{2008,8,22}, {17,16,17}} ==
            parse("Sat 22nd of August 2008 UTC", @date)
     assert {{2008,8,22}, {17,16,17}} ==
            parse("Sat 22nd of August 2008 DST", @date)
  end

  test "ISO formater" do
    source = "2007-12-24T18:12:00Z"
    date   = parse(source, @date)
    assert source == to_iso(date)
  end

end
