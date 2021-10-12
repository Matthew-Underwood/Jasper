extends Button


export(NodePath) var nodePath

func _pressed():
	var node = get_node(nodePath)
	node.visible = false
