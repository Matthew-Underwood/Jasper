class_name PathingFactory 

func create(obstacles : Array, map : Map) -> Pathing:
	var aStar = AStar.new()
	var pathing = load("res://classes/pathing/pathing.gd")
	pathing = pathing.new(aStar, map)
	var walkableTiles = pathing.addWalkableCells(obstacles)
	pathing.connectWalkableCells(walkableTiles)
	return pathing
