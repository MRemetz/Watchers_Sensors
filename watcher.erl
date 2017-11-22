-module(watcher).
-compile(export_all).

start() ->
    {ok, [N]} = io:fread("enter number of sensors> ", "~d"),
    if N =< 1 ->
          io:fwrite("setup: range must be at least 2~n", []);
       true ->
         setup_loop(N)
 end.

setup_loop(N) when N =< 10 ->
	spawn(?MODULE, make_watcher, [[[X, Y] || X <- lists:seq(1, N), Y <- [1]], N]);

setup_loop(N) when N>10 ->
	spawn(?MODULE, make_watcher, [[[X, Y] || X <- lists:seq(N-9, N), Y <-	[1]], 10]),
	setup_loop(N-10).

make_watcher(Sensor_list, 0) ->
	%io:format("Wid : ~w~n", [Wid]),
	watcher(Sensor_list);

make_watcher(Sensor_list, N) when N>=1->
	Sid = lists:nth(1, lists:nth(N, Sensor_list)),
	{Pid, _} = spawn_monitor(sensor, sensor, [self(), Sid]),
	make_watcher(lists:keyreplace(Sid, 1, Sensor_list, {Sid, Pid}), N-1).

watcher(Sensor_list) ->
	receive
		{Sid, Measurement} -> io:format("Received measurement ~w from sensor ~w~n",[self(),Sid,Measurement]),
							  watcher(Sensor_list)
		%{exit, Sid, Reason} -> io:format("~w~n exited with reason: ~w~n", [Sid, Reason])
	end. 
