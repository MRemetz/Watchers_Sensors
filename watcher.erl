-module(watcher).
-compile(export_all).
-import(sensor, [sensor/2]).

start() ->
    {ok, [N]} = io:fread("enter number of sensors> ", "~d"),
    if N =< 1 ->
          io:fwrite("setup: range must be at least 2~n", []);
       true ->
         Num_watchers = 1 + (N div 10),
         setup_loop(N)
 end.


setup_loop(N, 1) ->
	Wid = spawn(?MODULE, make_watcher, [self(), [{X, Y} || X <- lists:seq(1, N), Y <- [1]], N]);

setup_loop(N, Int) when N>10 ->
	Wid = spawn(?MODULE, make_watcher, [self(), [{X, Y} || X <- lists:seq(N-9, N), Y <-	[1]], 10]),
	setup_loop(N-10).

make_watcher(Wid, Sensor_list, 0) ->
	%print sensor_list
	watcher(Sensor_list);

make_watcher(Wid, Sensor_list, N) when N>=1->
	Sid = lists:nth(N, Sensor_list),
	{Pid, _} = spawn_monitor(?MODULE, sensor, [self(), Wid]),
	make_watcher(Wid, lists:keyreplace(Sid, 1, Sensor_list, {Sid, Pid}), N-1).

watcher(Sensor_list) ->
	io:format("watcher").
	%receives indefnitely
	%if receives 1-10, print sensor number and measurement
	%if receives crash, print sensor number, and crash
	%	spawn_monitor for that Sid, print updated list
	%	call itself with updated Sensor_list
