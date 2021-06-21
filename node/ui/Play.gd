extends Button

var buttonText : String = "Play"
var _timer : Timer

func setTurnTimer(timer : Timer):
	_timer = timer

func _on_Play_button_up():
	if buttonText == "Play":
		buttonText = "Stop"
		get_tree().call_group_flags(2, "characters", "setState", 1)
		_timer.start()
	else:
		buttonText = "Play"
		get_tree().call_group_flags(2, "characters", "resetState")
		_timer.stop()
		
	set_text(buttonText)
