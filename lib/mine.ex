
defmodule Mine do
  @moduledoc """
  Documentation for Mine.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Mine.hello
      :world

  """
    def main(args) do
        k = List.first(args)
        case String.length(k) < 3 do
          true -> 
            l = String.to_integer(k)
            MINE.Server.start_server(l)
          false ->
            MINE.Client.start_client(k)
        end
    end
end
