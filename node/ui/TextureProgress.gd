extends TextureProgress

var _timer : Timer
var _completed = false

func _process(delta):
	
	if _timer.is_stopped() && !_completed:
		value = 0
		return
	
	var timeTaken = _timer.get_wait_time() - _timer.get_time_left()
	value = timeTaken
		

func setTurnTimer(timer : Timer):
	_timer = timer
	
func resetProgress():
	_completed = false

func _on_TextureProgress_value_changed(value):
	if _timer.get_wait_time() == value:
		_completed = true
		
	if  value == 0:
		_completed = false
