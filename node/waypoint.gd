extends Node2D

var _selectedNode
var _plainNode
var _waypointParent


func _ready():
	add_to_group("waypoints")
	_selectedNode = get_node("Selected")
	_plainNode = get_node("Plain")

func _on_ChangeState_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("confirm_click"):
		get_tree().call_group_flags(2, "waypoints", "_deSelect")
		_selectedNode.visible = true
		_plainNode.visible = false
		get_tree().set_input_as_handled()

func _deSelect():
	_selectedNode.visible = false
	_plainNode.visible = true
