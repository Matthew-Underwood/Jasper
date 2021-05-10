class_name CharacterInfo

var _id : int
var _colour : Color
var _position : Vector2

func _init(id : int, colour : Color):
	_id = id
	_colour = colour
	
func getId() -> int:
	return _id
	
func setPosition(position : Vector2):
	_position = position
	
func getPosition() -> Vector2:
	return _position
	
func getColour():
	return _colour
	
