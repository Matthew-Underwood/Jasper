class_name WayPoints

var _waypoints = {}
var _characterId

	
func add(characterId : int, start : Vector2, end : Vector2):
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

func getLastItem(characterId : int) -> Dictionary:
	var size = _waypoints[characterId].size() - 1
	return _waypoints[characterId][size]
	
func has(characterId : int, waypointId : int) -> bool:
	if !_waypoints.has(characterId):
		return false
	if _waypoints[characterId].empty():
		return false
	return waypointId <= (_waypoints[characterId].size() - 1)
