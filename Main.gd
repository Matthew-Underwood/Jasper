extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var characterPositions = [Vector2(48, 48), Vector2(48, 496), Vector2(656, 496)]
	var characterScene = preload("res://character.tscn")
	var charactersNode = get_node("Characters")
	
	for characterNum in range(characterPositions.size()):
		var characterNode = characterScene.instance()
		characterNode.position = characterPositions[characterNum]
		charactersNode.add_child(characterNode)	
		
