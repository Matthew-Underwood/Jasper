extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_button_up():
	get_tree().call_group_flags(2, "characters", "setState", 1)


func _on_Back_button_up():
	get_tree().call_group_flags(2, "characters", "resetToStartingPosition")
