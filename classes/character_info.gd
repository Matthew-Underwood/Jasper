class_name CharacterInfo

var _id : int
var _colour : Color

func _init(id : int, colour : Color):
	_id = id
	_colour = colour
	
func getId() -> int:
	return _id
	
func getColour():
	return _colour
	
