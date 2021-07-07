extends TextureProgress

var _timer : Timer
var _completed = false
var _tween : Tween

func _ready():
	_tween = get_node("Tween")

func _process(delta):
	
	if _timer.is_stopped() && !_completed:
		value = min_value
		return
	value = max_value - (_timer.time_left / _timer.get_wait_time()) * max_value

func setTurnTimer(timer : Timer):
	_timer = timer
	
func resetProgress():
	_completed = false

func _on_TextureProgress_value_changed(changedValue):
	if max_value == changedValue:
		_completed = true
		
	if  changedValue == min_value:
		_completed = false

