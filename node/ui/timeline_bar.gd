extends TextureProgress

var _timer : Timer
var _completed = false
var _tween : Tween

func _ready():
	_tween = get_node("Tween")

func setTurnTimer(timer : Timer):
	_timer = timer
	
func fillProgress():
	_tween.interpolate_property(self, "value", 0, 100, 6.0, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	if !_tween.is_active():
		_tween.start()
	
	
func resetProgress():
	if _tween.is_active():
		_tween.stop(self, "value")
	_completed = false
