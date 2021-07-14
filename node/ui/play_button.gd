extends Button

var _parent : Control

func setParent(parent : Control):
	_parent = parent
	

func _on_Play_button_up():
	if text == "Play":
		_parent.startCountDown()
		changeButton("Stop")
		get_tree().call_group_flags(2, "characters", "setState", 1)
	else:
		changeButton("Play")
		_parent.setStatus(true)
		get_tree().call_group_flags(2, "characters", "resetState")

func changeButton(buttonName):
	set_text(buttonName)

