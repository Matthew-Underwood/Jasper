extends Node2D

var _selectedNode
var _plainNode
var _waypointParent

func _ready():
	_selectedNode = get_node("Selected")
	_plainNode = get_node("Plain")

func setWayPointParent(waypointParent):
	_waypointParent = waypointParent

func _on_ChangeState_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("confirm_click"):
		print("waypoint input")
		if !_waypointParent.get_children().empty():
			for waypoint in _waypointParent.get_children():
				waypoint.get_node("Selected").visible = false
				waypoint.get_node("Plain").visible = true
		_selectedNode.visible = true
		_plainNode.visible = false
		get_tree().set_input_as_handled()
