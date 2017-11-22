-module(sensor).
-compile(export_all).

sensor(Wid, Sid) ->
	io:format("Wid: ~w~n", [Wid]),
	io:format("Sid: ~w~n", [Sid]).
