class_name WayPoints

var _waypoints = {}
var _characterId : int

	
func add(characterId : int, start : Vector2, end : Vector2) -> void:
	if !_waypoints.has(characterId):
		_waypoints[characterId] = [{"start" : start , "end" : end}]
	else:
		_waypoints[characterId].append({"start" : start , "end" : end})
	
		
func getItem(characterId : int, waypointId : int) -> Dictionary:
	return _waypoints[characterId][waypointId]
	
	
func getAll(characterId : int) -> Array:
	return _waypoints[characterId]


func getCharacterIds() -> Array:
	var ids = []
	for id in _waypoints:
		ids.append(id)
	return ids
	
func remove(characterId : int, pos : Vector2):
	var ids = hasPosition(characterId, pos)
	var position
	var idToRemove
	var previousWaypointPosition
	var positionType
	
	if ids.empty():
		return false
		
	if ids.size() == 2:
		position = getItem(characterId, ids[1])
		idToRemove = ids[1]
		positionType = "start"
		
	else:
		position = getItem(characterId, ids[0])
		idToRemove = ids[0]
		positionType = "end"
		
		
	_waypoints[characterId][ids[0]]["end"] = position["end"]
	_waypoints[characterId].remove(idToRemove)
	if idToRemove != 0:
		previousWaypointPosition = _waypoints[characterId][idToRemove - 1][positionType]
		
	
	return previousWaypointPosition
	
		


func getLastItem(characterId : int) -> Dictionary:
	var size = _waypoints[characterId].size() - 1
	return _waypoints[characterId][size]
	
	
func has(characterId : int, waypointId : int) -> bool:
	if !_waypoints.has(characterId):
		return false
	if _waypoints[characterId].empty():
		return false
	return waypointId <= (_waypoints[characterId].size() - 1)
	
	
#TODO update this to return array of the index and start or end of the one to update
func hasPosition(characterId : int, pos : Vector2) -> Array:
	var found = []
	var count = 0
	if !has(characterId, 0):
		return found
	for waypoint in getAll(characterId):
		if waypoint["start"] == pos || waypoint["end"] == pos:
			found.append(count)
		count += 1
	return found
	
	
func updatePosition(characterId : int, ids : Array, positionToUpdate : Vector2) -> void:
	if ids.size() == 1:
		_waypoints[characterId][ids[0]]["end"] = positionToUpdate
		return
	if ids.size() == 2:
		_waypoints[characterId][ids[0]]["end"] = positionToUpdate
		_waypoints[characterId][ids[1]]["start"] = positionToUpdate
