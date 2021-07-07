extends Label

var _timer : Timer

func setTurnTimer(timer : Timer):
	_timer = timer

func _process(delta):
	if _timer.is_stopped():
		text = "0"
		return
	text = str(round(_timer.get_wait_time() - _timer.time_left))
