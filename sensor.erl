-module(sensor).
-compile(export_all).

sensor(Wid, Sid) ->
	Sleep_time = rand:uniform(10000),
	timer:sleep(Sleep_time),
	Measurement = rand:uniform(11),
	case Measurement of
		11 -> exit("anomalous_reading");
		_ok -> Wid!{Sid, Measurement},
			  sensor(Wid, Sid)
	end.
