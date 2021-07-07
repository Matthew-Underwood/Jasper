extends Button

var _timer : Timer
var _progressBar : TextureProgress

func setTurnTimer(timer : Timer):
	_timer = timer

func setProgressBar(progressBar : TextureProgress):
	_progressBar = progressBar

func _on_Play_button_up():
	if text == "Play":
		changeButton("Stop")
		get_tree().call_group_flags(2, "characters", "setState", 1)
		_timer.start()
	else:
		changeButton("Play")
		_progressBar.resetProgress()
		get_tree().call_group_flags(2, "characters", "resetState")
		_timer.stop()

func changeButton(buttonName):
	set_text(buttonName)

