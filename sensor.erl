-module(sensor).
-compile(export_all).

sensor(Wid, Sid) ->
	Sleep_time = rand:uniform(10000),
	timer:sleep(Sleep_time),
	Measurement = rand:uniform(10),
	case Measurement of
		%11 -> exit("Sensor ~w~d crashed", [Sid]);
		10 -> Wid!{Sid, Measurement},
			  sensor(Wid, Sid);
		_ -> Wid!{Sid, Measurement},
			 sensor(Wid, Sid)
	end.
