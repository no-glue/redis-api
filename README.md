# Redis api
Simple Redis api for Erlang

## How to use
erl -pa tell/ebin eredis/ebin

c(database). this will compile module

database:set_key(foo, bar).

database:get_key(foo).