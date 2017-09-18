defmodule MINE.Server do

	def start_server(k) do
		{:ok, ipcomb1} = :inet.getif()
		ipcomb2 = List.first(ipcomb1)
		size = Kernel.tuple_size(ipcomb2)
		ip = Kernel.elem(ipcomb2, 0)
		ipstr = :inet_parse.ntoa(ip)

		server_name = "001@#{ipstr}"
		Node.start(String.to_atom(server_name))
		chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()_+`~-={}[],./<>?"
		pid = spawn fn -> communicate(k, chars, 10000000000000, 0) end
		:global.register_name(@servername, pid)
		for n <- 1..3 do
			spawn fn -> mine_loop(pid) end
		end
		mine_loop(pid)
	end

	def mine_loop(pid) do
		send pid, {:request, self()}
		{k, start, limit} = get_input()
		MINE.Bitcoin.generate_coin(start, 0, 0, k, limit, pid)
		mine_loop(pid)
	end

	def get_input() do
		receive do
			{:hello, k, start, limit} -> {k, start, limit}
			_ -> {:error}
		end
	end

	def communicate(k, chars, limit, pos) do
		if pos < String.length(chars) do
			receive do
				{:request, pid} ->
					start = String.at(chars, pos)
					msg = {:hello, k, start, limit}
					send pid, msg
					communicate(k, chars, limit, pos + 1)
				{:coin, msg} ->
					print_valid(msg)
					communicate(k, chars, limit, pos)
			end
		end
	end



	def print_valid(input) do
		IO.puts ("#{input}\t#{MINE.Bitcoin.get_hash(input)}")
	end	

end