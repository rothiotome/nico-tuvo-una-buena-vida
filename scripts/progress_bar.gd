extends ProgressBar

var timer: SceneTreeTimer
var start_time: int

func initialize(temp: int) -> Signal:
	start_time = temp
	timer = get_tree().create_timer(temp)
	return timer.timeout

func _process(_delta):
	value = (timer.time_left / start_time) * 100
