extends Button

var buttonText : String = "Play"

func _on_Play_button_up():
	if buttonText == "Play":
		buttonText = "Pause"
		get_tree().call_group_flags(2, "characters", "setState", 1)
	else:
		buttonText = "Play"
		get_tree().call_group_flags(2, "characters", "setState", 0)
	set_text(buttonText)
