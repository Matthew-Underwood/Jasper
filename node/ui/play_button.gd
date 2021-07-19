extends Button

var _manager : Control

func setUiManager(manager : Control):
	_manager = manager

func _on_Play_button_up():
	if text == "Play":
		_manager.startCountDown()
		changeButton("Stop")
		get_tree().call_group_flags(2, "characters", "setState", 1)
	else:
		changeButton("Play")
		_manager.setStatus(true)
		get_tree().call_group_flags(2, "characters", "resetState")

func changeButton(buttonName):
	set_text(buttonName)

