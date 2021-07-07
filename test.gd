extends TextureProgress

var _timer : Timer
var _completed = false
var _tween : Tween
var _percentage = 0

signal update_percentage

func _ready():
	_tween = get_node("Tween")
	connect("update_percentage", self, "updatePercentage")

func _process(delta):
	if Input.is_key_pressed(KEY_A):
		emit_signal("update_percentage", 100)
	value = _percentage
	

func updatePercentage(percentage):
	print("Change " + str(percentage))
	_tween.interpolate_property(self, "_percentage", _percentage, percentage, 0.5)
	if not _tween.is_active():
		_tween.start()
