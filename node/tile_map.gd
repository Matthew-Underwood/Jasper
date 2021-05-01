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
var _waypointNode
var _wayPointParentNode

func _ready():
	_wayPointParentNode = get_tree().get_root().get_node("Node2D/WayPoints")
	var pathingFactory = load("res://classes/pathing_factory.gd")
	var waypoints = load("res://classes/pathing/waypoints.gd")
	var map = load("res://classes/map.gd")
	_waypointNode = load("res://scenes/waypoint.tscn")
	_waypoints = waypoints.new()
	_map = map.new(Vector2(32, 19))
	pathingFactory = pathingFactory.new()
	_pathing = pathingFactory.create(get_used_cells_by_id(0), _map)
	
func _draw():
	if _characterInfo == null:
		return
	var id = _characterInfo.getId()
	var colour = _characterInfo.getColour()
	
	if !_pointPaths.has(id) || _pointPaths[id].empty():
		return
		
	for index in range(1, len(_pointPaths[id])):
		var previousIndex = index - 1
		var lastPoint = map_to_world(Vector2(_pointPaths[id][previousIndex].x, _pointPaths[id][previousIndex].y)) + _halfCellSize
		var currentPoint = map_to_world(Vector2(_pointPaths[id][index].x, _pointPaths[id][index].y)) + _halfCellSize
		draw_line(lastPoint, currentPoint, colour, BASE_LINE_WIDTH, true)
		draw_circle(currentPoint, BASE_LINE_WIDTH * 2.0, colour)
		
func getPath(characterInfo : CharacterInfo):
	_characterInfo = characterInfo
	var currentId = _characterInfo.getId()
	for id in _waypoints.getCharacterIds():
		if id != currentId:
			_clearPreviousPathDrawing(id)
	_recalculatePath(currentId)
	if !_waypoints.has(currentId, 0):
		return
	for waypoint in _waypoints.getAll(currentId):
		_addWayPointNode(waypoint["end"])
		
		
func hasPath(characterInfo : CharacterInfo, targetPoint : Vector2) -> bool:
	return _waypoints.hasPosition(characterInfo.getId(), world_to_map(targetPoint))
	
func createPath(characterInfo : CharacterInfo, startPoint : Vector2, targetPoint : Vector2):
	
	_characterInfo = characterInfo
	var currentId = characterInfo.getId()
	var pathWorld = []
	self.pathStartPosition = startPoint
	self.pathEndPosition = targetPoint
	
	_recalculatePath(currentId)
	
	for point in _pointPaths[currentId]:
		var point_world = map_to_world(Vector2(point.x, point.y)) + _halfCellSize
		pathWorld.append(point_world)
	return pathWorld

func _recalculatePath(id : int):
	if !_waypoints.has(id, 0):
		return
		
	_pointPaths[id] = []
	
	for waypoint in _waypoints.getAll(id):
		var points = _pathing.getPath(waypoint["start"], waypoint["end"])
		for point in points:
			_pointPaths[id].append(point)
	
	update()
	
func _clearPreviousPathDrawing(id : int):
	if !_waypoints.has(id, 0):
		return
		
	for wayPoint in _wayPointParentNode.get_children():
		wayPoint.queue_free()
	update()
	
func _setPathStartPosition(value):
	value = world_to_map(value)
	if value in _obstacles:
		return
	if _map.isOutsideMapBounds(value):
		return
	pathStartPosition = value

func _setPathEndPosition(value):
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
	_addWayPointNode(value)
	pathEndPosition = value
	
	
func _getTileMapCentrePoint(mapPoint : Vector2) -> Vector2:
	var x = mapPoint.x * cell_size.x + (cell_size.x / 2)
	var y = mapPoint.y * cell_size.y + (cell_size.y / 2)
	return Vector2(x, y)
	
func _addWayPointNode(mapPoint : Vector2):
	var waypointNode = _waypointNode.instance()
	waypointNode.position = _getTileMapCentrePoint(mapPoint)
	_wayPointParentNode.add_child(waypointNode)	
