defmodule MINE.Client do
	def start_client(server_ip) do
		server_name = "001@#{server_ip}"

		{:ok, ipcomb1} = :inet.getif()
		ipcomb2 = List.first(ipcomb1)
		size = Kernel.tuple_size(ipcomb2)
		ip = Kernel.elem(ipcomb2, 0)
		ipstr = :inet_parse.ntoa(ip)

		client_name = "002@#{ipstr}"
		Node.start(String.to_atom(client_name))
		Node.connect(String.to_atom(server_name))
		for n <- 1..3 do
			spawn fn -> mine_loop() end
		end
		mine_loop()
	end

	def mine_loop() do
		pid = get_global()
		send pid, {:request, self()}
		{k, start, limit} = get_input()
		MINE.Bitcoin.generate_coin(start, 0, 0, k, limit, pid)
		mine_loop()
	end


	def get_input() do
		receive do
			{:hello, k, start, limit} -> {k, start, limit}
			_ -> {:error}
		end
	end

	def get_global() do
		ret = :global.whereis_name(@servername)
		case ret do
			:undefined -> get_global()
			_ -> ret
		end
	end
end