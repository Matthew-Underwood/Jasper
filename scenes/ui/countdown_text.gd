extends Label

var _timer : Timer
var _completed = false

func setTurnTimer(timer : Timer):
	_timer = timer

func _physics_process(delta):
	if _timer.is_stopped() && !_completed:
		text = "0"
		return
		
	if text == str(_timer.get_wait_time()):
		setComplete(true)
		
	if !_completed:
		text = str(_timer.get_wait_time() - _timer.time_left)
		print(text)

func setComplete(status : bool):
	_completed = status

func resetLabel():
	text = "0"
