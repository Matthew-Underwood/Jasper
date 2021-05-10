class_name Pathing

var _aStar : AStar
var _map : Map

func _init(aStar : AStar, map : Map):
	_aStar = aStar
	_map = map

# Loops through all cells within the map's bounds and
# adds all points to the _aStar, except the obstacles.
func addWalkableCells(obstacle_list = []):
	var points_array = []
	for y in range(_map.getSize().y):
		for x in range(_map.getSize().x):
			var point = Vector2(x, y)
			if point in obstacle_list:
				continue

			points_array.append(point)
			# The AStar class references points with indices.
			# Using a function to calculate the index from a point's coordinates
			# ensures we always get the same index with the same input point.
			var point_index = _calculatePointIndex(point)
			# AStar works for both 2d and 3d, so we have to convert the point
			# coordinates from and to Vector3s.
			_aStar.add_point(point_index, Vector3(point.x, point.y, 0.0))
	return points_array

func isWalkable(point : Vector2) -> bool:
	var pointIndex = _calculatePointIndex(point)
	return _aStar.has_point(pointIndex)
	

# Once you added all points to the AStar node, you've got to connect them.
# The points don't have to be on a grid: you can use this class
# to create walkable graphs however you'd like.
# It's a little harder to code at first, but works for 2d, 3d,
# orthogonal grids, hex grids, tower defense games...
func connectWalkableCells(points_array):
	for point in points_array:
		var point_index = _calculatePointIndex(point)
		# For every cell in the map, we check the one to the top, right.
		# left and bottom of it. If it's in the map and not an obstalce.
		# We connect the current point with it.
		var points_relative = PoolVector2Array([
			point + Vector2.RIGHT,
			point + Vector2.LEFT,
			point + Vector2.DOWN,
			point + Vector2.UP,
		])
		for point_relative in points_relative:
			var point_relative_index = _calculatePointIndex(point_relative)
			if _map.isOutsideMapBounds(point_relative):
				continue
			if not _aStar.has_point(point_relative_index):
				continue
			# Note the 3rd argument. It tells the _aStar that we want the
			# connection to be bilateral: from point A to B and B to A.
			# If you set this value to false, it becomes a one-way path.
			# As we loop through all points we can set it to false.
			_aStar.connect_points(point_index, point_relative_index, false)


# This is a variation of the method above.
# It connects cells horizontally, vertically AND diagonally.
func connectWalkableCells_diagonal(points_array):
	for point in points_array:
		var point_index = _calculatePointIndex(point)
		for local_y in range(3):
			for local_x in range(3):
				var point_relative = Vector2(point.x + local_x - 1, point.y + local_y - 1)
				var point_relative_index = _calculatePointIndex(point_relative)
				if point_relative == point or _map.isOutsideMapBounds(point_relative):
					continue
				if not _aStar.has_point(point_relative_index):
					continue
				_aStar.connect_points(point_index, point_relative_index, true)

func getPath(path_start_position : Vector2, path_end_position : Vector2):
	var start_point_index = _calculatePointIndex(path_start_position)
	var end_point_index = _calculatePointIndex(path_end_position)
	if !_aStar.has_point(start_point_index) or !_aStar.has_point(end_point_index):
		return null
	return _aStar.get_point_path(start_point_index, end_point_index)

func _calculatePointIndex(point):
	return point.x + _map.getSize().x * point.y


