extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var characterPositions = [Vector2(48, 48), Vector2(48, 496), Vector2(656, 496)]
	var characterColours = [Color.green, Color.red, Color.red]
	var characterScene = preload("res://scenes/character.tscn")
	var characterInfo = load("res://classes/character_info.gd")
	var charactersNode = get_node("Characters")
	var timer = get_node("Timer")
	var tileMap = get_node("TileMap")
	var playButton = get_node("Panel/Panel/HSplitContainer/Play")
	var countDownText = get_node("Panel/CountdownText")
	var timelineBar = get_node("Panel/TextureProgress")
	var parent = get_node("Panel")
	timer.connect("timeout", parent, "setStatus", [false])
	parent.setTimer(timer)
	parent.setLabel(countDownText)
	parent.setProgressBar(timelineBar)
	playButton.setParent(parent)
	
	
	for characterNum in range(characterPositions.size()):
		var characterNode = characterScene.instance()
		timer.connect("timeout", characterNode, "pauseState")
		timer.connect("timeout", timelineBar, "expireTimer")
		var characterInfoInstance = characterInfo.new(characterNum, characterColours[characterNum], Color.aquamarine)
		characterNode.setTileMap(tileMap)
		characterNode.setCharacterInfo(characterInfoInstance)
		characterNode.position = characterPositions[characterNum]
		characterNode.modulate = characterColours[characterNum]
		charactersNode.add_child(characterNode)	
		
