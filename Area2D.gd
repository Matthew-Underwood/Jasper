extends Area2D


func _input_event(camera, event, id):
	if event.is_action_pressed("click"):
		var tileMap = get_node("/root/Node2D/TileMap")
		var characterInfo = get_parent().getCharacterInfo()
		tileMap.getPath(characterInfo)
