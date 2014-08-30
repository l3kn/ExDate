defmodule ExDate.Tokeniser do
  # Helper Guards
  defmacro is_num?(char) do
    # 48 => '0', 57 => '9'
    quote do unquote(char) >= 48 and unquote(char) <= 57 end
  end

  def tokenise([], acc), do: Enum.reverse acc

  # Convert 1 to 6 digit long numbers

  def tokenise([n1, n2, n3, n4, n5, n6 | rest], acc) when
    is_num?(n1) and is_num?(n2) and is_num?(n3) and is_num?(n4) and
    is_num?(n5) and is_num?(n6) do
      tokenise(rest, [List.to_integer([n1, n2, n3, n4, n5, n6]) | acc])
  end

  def tokenise([n1, n2, n3, n4, n5 | rest], acc) when
    is_num?(n1) and is_num?(n2) and is_num?(n3) and is_num?(n4) and
    is_num?(n5) do
      tokenise(rest, [List.to_integer([n1, n2, n3, n4, n5]) | acc])
  end

  def tokenise([n1, n2, n3, n4 | rest], acc) when
    is_num?(n1) and is_num?(n2) and is_num?(n3) and is_num?(n4) do
      tokenise(rest, [List.to_integer([n1, n2, n3, n4]) | acc])
  end

  def tokenise([n1, n2, n3 | rest], acc) when
    is_num?(n1) and is_num?(n2) and is_num?(n3) do
      tokenise(rest, [List.to_integer([n1, n2, n3]) | acc])
  end

  def tokenise([n1, n2 | rest], acc) when
    is_num?(n1) and is_num?(n2) do
      tokenise(rest, [List.to_integer([n1, n2]) | acc])
  end

  def tokenise([n1 | rest], acc) when
    is_num?(n1) do
      tokenise(rest, [List.to_integer([n1]) | acc])
  end

  # Convert worded months, seperators and am/pm

  monthnames = [{['JANUARY', 'JAN'], 1},
                {['FEBRURAY', 'FEB'], 2},
                {['MARCH', 'MAR'], 3},
                {['APRIL', 'APR'], 4},
                {['MAY'], 5},
                {['JUNE', 'JUN'], 6},
                {['JULY', 'JUL'], 7},
                {['AUGUST', 'AUG'], 8},
                {['SEPTEMBER', 'SEPT', 'SEP'], 9},
                {['OCTOBER', 'OCT'], 10},
                {['NOVEMBER', 'NOVEM', 'NOV'], 11},
                {['DECEMBER', 'DECEM', 'DEC'], 12}]

  for {names, num} <- monthnames do
    for name <- names do
      def tokenise(unquote(name)++rest, acc) do
        tokenise(rest, [{:month, unquote(num)} | acc])
      end
    end
  end

  conversions = [{[':'], ':'}, {['/'], '/'}, {['-'], '-'},
                 {['Z'], 'Z'}, {['.'], '.'}, {['+'], '+'},
                 {['AM', 'A'], :am}, {['PM', 'P'], :pm}]

  for {froms, to} <- conversions do
    for from <- froms do
      def tokenise(unquote(from)++rest, acc) do
        tokenise(rest, [unquote(to) | acc])
      end
    end
  end


  # Delete worded weekdays, spacing and suffixes

  deletions = ['MONDAY', 'MON', 'TUESDAY', 'TUES', 'TUE', 'WEDNESDAY', 'WEDS',
               'WED', 'THURSDAY', 'THURS', 'THUR', 'THU', 'FRIDAY', 'FRI',
               'SATURDAY', 'SAT', 'SUNDAY', 'SUN',
               'GMT', 'UTC', 'DST', 'EDT', 'EST',
               ',', ' ', 'TH', 'ND', 'ST', 'OF', 'T']

  for deletion <- deletions do
    def tokenise(unquote(deletion)++rest, acc), do: tokenise(rest, acc)
  end

  # Handle bad tokens

  def tokenise([bad | rest], acc), do: tokenise(rest, [{:bad_token, bad}, acc])
end
