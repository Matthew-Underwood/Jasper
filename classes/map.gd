class_name Map

var _size : Vector2

func _init(size : Vector2):
	_size = size
	
func getSize() -> Vector2: 
	return _size
	
func isOutsideMapBounds(point : Vector2) -> bool:
	return point.x < 0 or point.y < 0 or point.x >= _size.x or point.y >= _size.y
