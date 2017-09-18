defmodule MINE.Bitcoin do

  def get_hash(input) do
    :crypto.hash(:sha256, input) |> Base.encode16
  end

  def get_k_zero(k) do
    for n <- 1..k, do: 0
  end

  def check_valid?(input, k) do
    k_zero = get_k_zero(k)
    k_zero_str = Enum.join(k_zero, "")
    k_leading_str = String.slice(input, 0, k)
    String.equivalent?(k_leading_str, k_zero_str)
  end

  def check_str_valid?(input, k) do
    str = get_hash(input)
    check_valid?(str, k)
  end

  def generate_str(id, i) do
    j = 1 + i
    "#{"hjin91;"}#{id}#{j}"
  end



  def generate_coin(id, i, num, k, limit, print_pid) do

      str = generate_str(id, i)
      valid = check_str_valid?(str, k)

      case valid do
        true -> 
          msg = {:coin, str}
          send print_pid, msg
        false -> "not valid"
      end

      case valid do
        true -> case i >= limit do
                  true -> "stop"
                  false -> generate_coin(id, i + 1, num + 1, k, limit, print_pid)
                end
        false -> generate_coin(id, i + 1, num, k, limit, print_pid)
      end
  end


end




