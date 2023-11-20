extends BasePopup

class_name EventPopup

@export var progress_bar_node: PackedScene
@export var options_node: PackedScene
@export var option_node: PackedScene

@onready var window = $MarginContainer/Window

var event: Dictionary

func initialize(new_event):
	event = new_event

func _ready():
	var message = message_node.instantiate() as Label
	message.text = (event["text"])
	window.add_child(message)
	
	if event.has("options") and !event["options"].is_empty():
		var options = options_node.instantiate()
		window.add_child(options)
		for o in event["options"]:
			var option = option_node.instantiate() as Button
			if Timmy.has_required(o["required"]):
				option.set_text(o["text"])
				options.add_child(option)
				for n in o["effects"]:
					option.set_meta(n, o["effects"][n])
				option.pressed.connect(Timmy.on_response.bind(option))
				option.pressed.connect(queue_free)
	if event["duration"] > 0:
		var progress_bar = progress_bar_node.instantiate() as ProgressBar
		window.add_child(progress_bar)
		progress_bar.initialize(event["duration"]).connect(on_timeout)
	
func on_timeout():
	if event.has("no_response"):
		Timmy.on_event_not_responded(event["no_response"])
	queue_free()
