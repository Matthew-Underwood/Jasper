class_name CharacterInfo

var _id : int
var _colour : Color
var _highlightedColour : Color
var _position : Vector2


func _init(id : int, colour : Color, highlightedColour : Color):
	_id = id
	_colour = colour
	_highlightedColour = highlightedColour
	
	
func getId() -> int:
	return _id
	
	
func setPosition(position : Vector2):
	_position = position
	
	
func getPosition() -> Vector2:
	return _position

func getHighlightedColour() -> Color:
	return _highlightedColour
	
func getColour() -> Color:
	return _colour
	
