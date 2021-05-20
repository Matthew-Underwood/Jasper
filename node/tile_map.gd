extends TileMap

const BASE_LINE_WIDTH = 1.0
const DRAW_COLOR = Color.white
var _characterInfo : CharacterInfo
var _map : Map
var _pointPaths : Dictionary
var _halfCellSize = cell_size / 2
var pathStartPosition = Vector2() setget _setPathStartPosition
var pathEndPosition = Vector2() setget _setPathEndPosition
var _pathing : Pathing
var _obstacles : Array
var _waypoints: WayPoints
var _waypointIds
var _clickedPos

func _ready():
	var pathingFactory = load("res://classes/pathing/pathing_factory.gd")
	var waypoints = load("res://classes/waypoints.gd")
	var map = load("res://classes/map.gd")
	_waypoints = waypoints.new()
	_map = map.new(Vector2(32, 19))
	pathingFactory = pathingFactory.new()
	_pathing = pathingFactory.create(get_used_cells_by_id(0), _map)
	
	
func _draw():
	if _characterInfo == null:
		return
	
	_clearCellsById(2)
	_clearCellsById(3)
	var id = _characterInfo.getId()
	var colour = _characterInfo.getColour()
	
	if !_pointPaths.has(id) || _pointPaths[id].empty():
		return
	
	for waypoint in _waypoints.getAll(id):
		set_cellv(waypoint["end"], 2)
	
	if _clickedPos != null and get_cellv(_clickedPos) == 2:
		set_cellv(_clickedPos, 3)
		
	for index in range(1, len(_pointPaths[id])):
		var previousIndex = index - 1
		var lastPoint = map_to_world(Vector2(_pointPaths[id][previousIndex].x, _pointPaths[id][previousIndex].y)) + _halfCellSize
		var currentPoint = map_to_world(Vector2(_pointPaths[id][index].x, _pointPaths[id][index].y)) + _halfCellSize
		draw_line(lastPoint, currentPoint, colour, BASE_LINE_WIDTH, true)
		draw_circle(currentPoint, BASE_LINE_WIDTH * 2.0, colour)
		
		
func _process(delta : float):
	if _characterInfo == null:
		return
	var id = _characterInfo.getId()
	if Input.is_action_just_pressed("confirm_click"):
		var mousePos = world_to_map(get_viewport().get_mouse_position())
		if _mousePositionMatchesCharacter(mousePos):
			return
		if !_pathing.isWalkable(mousePos):
			return
		_waypointIds = _waypoints.getIdsFromPosition(id, mousePos)
		_clickedPos = mousePos
			
	#TODO return false if null in WayPoint class
	if Input.is_action_pressed("confirm_click") && _waypointIds != null && !_waypointIds.empty():
		var mousePos = world_to_map(get_viewport().get_mouse_position())
		_clickedPos = mousePos
		if _mousePositionMatchesCharacter(mousePos):
			return
		if !_pathing.isWalkable(mousePos):
			return
		_waypoints.updatePosition(id, _waypointIds, mousePos)
		_recalculatePath()
		update()
		
	if Input.is_action_just_pressed("delete_waypoint") and _clickedPos != null:
		set_cellv(_clickedPos, -1)
		var previousWaypointPos = _waypoints.remove(id, _clickedPos)
		if typeof(previousWaypointPos) == TYPE_VECTOR2:
			_clickedPos = previousWaypointPos
		_recalculatePath()
		update()


func showPath(characterInfo : CharacterInfo) -> void:
	_characterInfo = characterInfo
	_recalculatePath()
	update()


func hasPath(characterInfo : CharacterInfo, targetPoint : Vector2) -> bool:
	var worldPos = world_to_map(targetPoint)
	return !_waypoints.getIdsFromPosition(characterInfo.getId(), worldPos).empty()


func isWalkable(pos : Vector2) -> bool:
	return _pathing.isWalkable(world_to_map(pos))
	
	
func getPath(characterInfo : CharacterInfo) -> Array:
	var currentId = characterInfo.getId()
	var pathWorld = []
	for point in _pointPaths[currentId]:
		var pointWorld = map_to_world(Vector2(point.x, point.y)) + _halfCellSize
		pathWorld.append(pointWorld)
	return pathWorld


func createPath(characterInfo : CharacterInfo, targetPoint : Vector2) -> void:
	_characterInfo = characterInfo
	var currentId = characterInfo.getId()
	var pathWorld = []
	self.pathStartPosition = _characterInfo.getPosition()
	self.pathEndPosition = targetPoint
	_recalculatePath()
	update()

func _recalculatePath() -> void:
	var pointPaths = []
	var id = _characterInfo.getId()
	if !_waypoints.has(id, 0):
		_pointPaths[id] = pointPaths
		return
	
	for waypoint in _waypoints.getAll(id):
		var points = _pathing.getPath(waypoint["start"], waypoint["end"])
		if points == null:
			return
		for point in points:
			pointPaths.append(point)
	_pointPaths[id] = pointPaths


func _setPathStartPosition(value) -> void:
	value = world_to_map(value)
	if value in _obstacles:
		return
	if _map.isOutsideMapBounds(value):
		return
	pathStartPosition = value


func _setPathEndPosition(value) -> void:
	value = world_to_map(value)
	if value in _obstacles:
		return
	if _map.isOutsideMapBounds(value):
		return
	if !_waypoints.has(_characterInfo.getId(), 0):
		_waypoints.add(_characterInfo.getId(), pathStartPosition, value)
	else:
		var lastItem = _waypoints.getLastItem(_characterInfo.getId())
		_waypoints.add(_characterInfo.getId(), lastItem["end"], value)
	pathEndPosition = value


func _mousePositionMatchesCharacter(mousePos : Vector2) -> bool:
	return mousePos == world_to_map(_characterInfo.getPosition())


func _clearCellsById(id : int) -> void:
	for usedCell in get_used_cells_by_id(id):
		set_cellv(usedCell, -1)

