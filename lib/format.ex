defmodule ExDate.Formatter do
  @iso "~4.10.0B-~2.10.0B-~2.10.0BT~2.10.0B:~2.10.0B:~2.10.0BZ"

  def format(:iso, {{yr, mon, day}, {hr, min, sec}}) do
    :io_lib.format(@iso, [yr, mon, day, hr, min, sec])
  end
end


