extends Node2D

var _selectedNode
var _plainNode
var _waypointParent
var _selected
var _tileMap
var _validMouseAction 
var _drag


func _ready():
	add_to_group("waypoints")
	_selectedNode = get_node("Selected")
	_plainNode = get_node("Plain")
	get_tree().call_group_flags(2, "waypoints", "_deSelect")
	_select()

	
func setTileMap(tileMap : TileMap):
	_tileMap = tileMap


func _process(delta):
	if Input.is_action_just_released("confirm_click"):
		_drag = false
		
	if Input.is_action_just_pressed("confirm_click") && _validMouseAction:
		_drag = true
		get_tree().call_group_flags(2, "waypoints", "_deSelect")
		_select()
	
	if Input.is_action_pressed("confirm_click") && _drag:
		var pos = get_viewport().get_mouse_position()
		if _tileMap.isWalkable(pos):
			position = _tileMap._getTileMapCentrePoint(_tileMap.world_to_map(pos))


func _select():
	_selected = true
	_selectedNode.visible = true
	_plainNode.visible = false


func _deSelect():
	_selected = false
	_selectedNode.visible = false
	_plainNode.visible = true


func _on_ChangeState_mouse_entered():
	_validMouseAction = true


func _on_ChangeState_mouse_exited():
	_validMouseAction = false
