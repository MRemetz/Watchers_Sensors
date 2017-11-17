-module(watcher).
-compile(export_all).

start() ->
    {ok, [N]} = io:fread("enter number of sensors> ", "~d") ,
    if N =< 1 ->
          io:fwrite("setup: range must be at least 2~n", []) ;
       true -> 
         Num_watchers = 1 + (N div 10),
         setup_loop(N, Num_watchers) 
 end.


setup_loop(N, 1) ->
	make_watcher([{N, P} || N <- lists:seq(N, 1), P <- [0], N);

setup_loop(N, Num_watchers) when N>10 ->
	make_watcher([{N, P} || N <- lists:seq(N, N-9), P <- [0]], 10),
	setup_loop(N-10, Num_watchers-1).

make_watcher(Sensor_list, 0) ->
	%print sensor_list
	watcher(Sensor_list);

make_watcher(Sensor_list, N) when N>=1->
	Snum = lists:nth(N, list),
	{Pid, _} = spawn_monitor(?MODULE, sensor:sensor, [self()]),
	make_watcher(lists:keyreplace(Snum, 1, Sensor_list, {Snum, Pid}), N-1).

watcher(Sensor_list) ->
	%receives indefnitely
	%if receives 1-10, print
	%if receives 11, spawn_monitor for that Snum, call itself with updates Sensor_list

