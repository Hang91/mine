# distributed bitcoin mining simulator
used Elixir, actor model

try to find the result of SHA-256 with certain number of leading 0s.

in mac OS, use command line below start server

mix escript/build

./mine num

note: num is the number of leading 0s

use command line below to start client in same LAN with server

./mine IPaddress of server

note: self IP address getting method is different among different operating system, please check the position of self IP in the result of  :inet.getif()


