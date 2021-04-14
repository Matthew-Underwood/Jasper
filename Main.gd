extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var characterPositions = [Vector2(48, 48), Vector2(48, 496), Vector2(656, 496)]
	var characterColours = [Color.green, Color.red, Color.red]
	var characterScene = preload("res://character.tscn")
	var characterInfo = load("res://classes/character_info.gd")
	var charactersNode = get_node("Characters")
	
	
	for characterNum in range(characterPositions.size()):
		var characterNode = characterScene.instance()
		var characterInfoInstance = characterInfo.new(characterNum, characterColours[characterNum])
		characterNode.setCharacterInfo(characterInfoInstance)
		characterNode.position = characterPositions[characterNum]
		characterNode.modulate = characterColours[characterNum]
		charactersNode.add_child(characterNode)	
		
