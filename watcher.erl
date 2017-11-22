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
	spawn(?MODULE, make_watcher, [[{X, Y} || X <- lists:seq(1, N), Y <- [1]], N]);

setup_loop(N) when N>10 ->
	spawn(?MODULE, make_watcher, [[{X, Y} || X <- lists:seq(N-9, N), Y <-	[1]], 10]),
	setup_loop(N-10).

make_watcher(Sensor_list, 0) ->
	io:fwrite("Initial Sensor List for ~w: ~w~n", [self(), Sensor_list]),
	watcher(Sensor_list);

make_watcher(Sensor_list, N) when N>=1->
	{Sid, _} = lists:nth(N, Sensor_list),
	{Pid, _} = spawn_monitor(sensor, sensor, [self(), Sid]),
	make_watcher(lists:keyreplace(Sid, 1, Sensor_list, {Pid, Sid}), N-1).

watcher(Sensor_list) ->
	receive
		{Sid, Measurement} ->
			io:fwrite("~w : ~w~n",[Sid,Measurement]),
			watcher(Sensor_list);
		{'DOWN',_,_,Pid,Reason} ->
			Sid = proplists:get_value(Pid, Sensor_list),
			io:fwrite("~w : ~w~n", [Sid, Reason]),
			{NewPid, _} = spawn_monitor(sensor, sensor, [self(), Sid]),
			Newlist = lists:keyreplace(Pid, 1, Sensor_list, {NewPid, Sid}),
			io:fwrite("Updated Sensor List for ~w: ~w~n", [self(), Newlist]),
			watcher(Newlist)
	end.
