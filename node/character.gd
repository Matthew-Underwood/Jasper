extends Node2D

enum States { IDLE, FOLLOW }
const MASS = 10.0
const ARRIVE_DISTANCE = 10.0

export(float) var speed = 120.0
var _state = null

var _path = []
var _targetPointWorld = Vector2()
var _targetPosition = Vector2()
var _startingPosition = Vector2()

var _velocity = Vector2()
var _characterInfo : CharacterInfo
var _tileMap : TileMap
var _pathIndex = 1


func _ready():
	add_to_group("characters")
	_startingPosition = position


func _process(_delta):
	if _state != States.FOLLOW:
		return
	var path = _tileMap.getPath(_characterInfo)
	var targetPoint = path[_pathIndex]
	var arrivedToNextPoint = _move_to(targetPoint)
	if arrivedToNextPoint:
		_pathIndex = _pathIndex + 1
		if _pathIndex == (path.size()):
			_pathIndex = 1
			setState(States.IDLE)
			return


func setCharacterInfo(characterInfo : CharacterInfo):
	_characterInfo = characterInfo


#TODO this is going to evolve over time. 
func resetToStartingPosition() -> void:
	position = _startingPosition

	
func setTileMap(tileMap : TileMap):
	_tileMap = tileMap


func setState(state):
	_state = state

	
func getCharacterInfo():
	return _characterInfo
	
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("confirm_click"):
		_targetPosition = get_global_mouse_position()
		_characterInfo.setPosition(position)
		#TODO is this misleading? Its checking for waypoint exists not the path
		if _tileMap.hasPath(_characterInfo, _targetPosition):
			return
		if !_tileMap.isWalkable(_targetPosition):
			return
		_tileMap.createPath(_characterInfo, _targetPosition)


func _move_to(worldPosition):
	var desiredVelocity = (worldPosition - position).normalized() * speed
	var steering = desiredVelocity - _velocity
	_velocity += steering / MASS
	position += _velocity * get_process_delta_time()
	rotation = _velocity.angle()
	return position.distance_to(worldPosition) < ARRIVE_DISTANCE


func _on_Area2D_mouse_entered():
	var characters = get_tree().get_nodes_in_group("characters")
	for character in characters:
		character.set_process_unhandled_input(false)


func _on_Area2D_mouse_exited():
	set_process_unhandled_input(true)


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("confirm_click"):
		_tileMap.showPath(_characterInfo)

