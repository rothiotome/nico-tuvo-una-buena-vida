extends PanelContainer

class_name EventPopup

@export var progress_bar_node: PackedScene
@export var message_node: PackedScene
@export var options_node: PackedScene
@export var option_node: PackedScene

@onready var window = $MarginContainer/Window

var event: Dictionary

var dragging: bool
var offset

func initialize(new_event: Dictionary):
	event = new_event

func _ready():
	var message = message_node.instantiate() as RichTextLabel
	message.add_text(event["text"])
	window.add_child(message)
	
	if !event["options"].is_empty():
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

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if get_viewport_rect().has_point(event.global_position):
					grab_focus()
					offset = event.global_position - position
					dragging = true
			else:
				release_focus()
				dragging = false

	elif event is InputEventMouseMotion:
		if dragging:
			var new_position = event.global_position - offset
			new_position.x = clamp(new_position.x, 0, get_viewport_rect().size.x - size.x)
			new_position.y = clamp(new_position.y, 0, get_viewport_rect().size.y - size.y)
			position = new_position
