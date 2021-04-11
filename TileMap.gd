extends TileMap

const BASE_LINE_WIDTH = 1.0
const DRAW_COLOR = Color.white
var _map : Map
var _pointPath = []
var _halfCellSize = cell_size / 2
var pathStartPosition = Vector2() setget _setPathStartPosition
var pathEndPosition = Vector2() setget _setPathEndPosition
var _pathing : Pathing
var _obstacles : Array

func _ready():
	var pathingFactory = load("res://classes/pathing_factory.gd")
	var map = load("res://classes/map.gd")
	_map = map.new(Vector2(32, 19))
	pathingFactory = pathingFactory.new()
	_pathing = pathingFactory.create(get_used_cells_by_id(0), _map)
	
func _draw():
	if not _pointPath:
		return
	var point_start = _pointPath[0]
	var point_end = _pointPath[len(_pointPath) - 1]

	set_cell(point_start.x, point_start.y, 1)
	set_cell(point_end.x, point_end.y, 2)

	var last_point = map_to_world(Vector2(point_start.x, point_start.y)) + _halfCellSize
	for index in range(1, len(_pointPath)):
		var current_point = map_to_world(Vector2(_pointPath[index].x, _pointPath[index].y)) + _halfCellSize
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		draw_circle(current_point, BASE_LINE_WIDTH * 2.0, DRAW_COLOR)
		last_point = current_point
		
		
func getPath(world_start, world_end):
	self.pathStartPosition = world_to_map(world_start)
	self.pathEndPosition = world_to_map(world_end)
	_recalculatePath()
	var path_world = []
	for point in _pointPath:
		var point_world = map_to_world(Vector2(point.x, point.y)) + _halfCellSize
		path_world.append(point_world)
	return path_world

func _recalculatePath():
	_clearPreviousPathDrawing()
	# This method gives us an array of points. Note you need the start and
	# end points' indices as input.
	_pointPath = _pathing.getPath(pathStartPosition, pathEndPosition)
	# Redraw the lines and circles from the start to the end point.
	update()
	
func _clearPreviousPathDrawing():
	if not _pointPath:
		return
	var point_start = _pointPath[0]
	var point_end = _pointPath[len(_pointPath) - 1]
	set_cell(point_start.x, point_start.y, -1)
	set_cell(point_end.x, point_end.y, -1)

# Setters for the start and end path values.
func _setPathStartPosition(value):
	if value in _obstacles:
		return
	if _map.isOutsideMapBounds(value):
		return

	set_cell(pathStartPosition.x, pathStartPosition.y, -1)
	set_cell(value.x, value.y, 1)
	pathStartPosition = value
	if pathEndPosition and pathEndPosition != pathStartPosition:
		_recalculatePath()


func _setPathEndPosition(value):
	if value in _obstacles:
		return
	if _map.isOutsideMapBounds(value):
		return

	set_cell(pathStartPosition.x, pathStartPosition.y, -1)
	set_cell(value.x, value.y, 2)
	pathEndPosition = value
	if pathStartPosition != value:
		_recalculatePath()
