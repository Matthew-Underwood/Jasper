extends Control


var _timer : Timer
var _dormant = true
var _progressBar : TextureProgress
var _label : Label

func setTimer(timer : Timer):
	_timer = timer

func setLabel(label : Label):
	_label = label
	
func setProgressBar(progressBar : TextureProgress):
	_progressBar = progressBar

func startCountDown():
	_timer.start()

func setStatus(status : bool):
	_dormant = status
	_timer.stop()
	
func _physics_process(delta):
	if  _timer.is_stopped() and _dormant:
		_label.text = _getTimeLeft(true)
		_progressBar.value = _getPercentLeft(true)
		return
		
	_label.text = _getTimeLeft()
	_progressBar.value = _getPercentLeft()

func _getTimeLeft(reset = false):
	var time
	if !reset:
		time = _timer.get_wait_time() - _timer.time_left
	else:
		time = 0 
	return str(floor(time))

func _getPercentLeft(reset = false):
	var precent
	if !reset:
		precent = 100 - (_timer.time_left / _timer.get_wait_time()) * 100
	else:
		precent = 0 
	return precent

