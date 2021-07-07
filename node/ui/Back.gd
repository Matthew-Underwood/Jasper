extends Button


func _on_Back_button_up():
	get_tree().call_group_flags(2, "characters", "resetState")
