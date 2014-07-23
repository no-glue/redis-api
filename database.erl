-module(database).
-export([start/0, stop/0, test/0, set_key/2, get_key/1, init/1]).

start()->Db = db_start(), register(database, spawn(database, init, [Db])).
% gets process looping

stop()->me(stop).
% stops process

test()->me(test).
% test process, see if it's running, get some basic stats

get_key(Key)->me({get, [Key]}).
% tells me to get key

set_key(Key, Value)->me({set, [Key, Value]}).
% tells me to set key

init(Db)->loop(Db).

loop(Db)->
  receive
    {request, Pid, Message}->
      received(request, Pid, Message, Db)
  end.
% listens messages
% stop stops the process

me(Message)->tell:tell(database, Message).
% tells me what to do

received(request, Pid, stop, Db)->tell:reply(Pid, ok);
% received stop
received(request, Pid, test, Db)->tell:reply(Pid, Db), loop(Db);
% received test
received(request, Pid, {get, Key}, Db)->tell:reply(Pid, db_get(Key, Db)), loop(Db);
% received get key
received(request, Pid, {set, KeyValue}, Db)->tell:reply(Pid, db_set(KeyValue, Db)), loop(Db).
% received set key

db_start()->{ok, Db} = eredis:start_link(), Db.
% start db

db_get(Key, Db)->{ok, Values} = eredis:q(Db, ["GET" | Key]), Values.
% get values from db

db_set(KeyValue, Db)->eredis:q(Db, ["SET" | KeyValue]),ok.
% set values in db