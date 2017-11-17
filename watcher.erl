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
	make_watcher(N || N <- lists:seq(N, 1));

setup_loop(N, Num_watchers) when N>10 ->
	make_watcher([N || N <- lists:seq(N, N-9)]),
	setup_loop(N-10, Num_watchers-1).

make_watcher([]) ->
	watcher();

make_watcher(sensor_list)->
	spawn_monitor()
