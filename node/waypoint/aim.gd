extends Button

var _facingCharacter : Node2D

func _ready():
	set_process(false)
	set_process_unhandled_input(false)
	
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("confirm_click"):
		set_process(false)
		set_process_unhandled_input(false)
	
	
func _pressed():
	var tree = get_tree()
	if tree.has_group("characters"):
		var characters = tree.get_nodes_in_group("characters")
		for character in characters:
			if character.isSelected():
				set_process(true)
				set_process_unhandled_input(true)
				_facingCharacter = character


func _process(delta : float) -> void:
	var pos = get_viewport().get_mouse_position()
	_facingCharacter.look_at(pos)
