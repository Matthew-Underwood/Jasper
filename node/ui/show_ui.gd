extends Button


export(NodePath) var nodePath

func _pressed():
	var nodesToHide = get_tree().get_nodes_in_group("UI")
	for nodetoHide in nodesToHide:
		nodetoHide.visible = false
		
	var nodeToShow = get_node(nodePath)
	nodeToShow.visible = true
