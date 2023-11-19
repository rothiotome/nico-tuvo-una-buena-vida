extends PanelContainer

class_name BasePopup

@export var message_node: PackedScene

var dragging: bool
var offset: Vector2

func initialize(settings: Variant):
	pass

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if get_viewport_rect().has_point(event.global_position):
					grab_focus()
					top_level = true
					offset = event.global_position - position
					dragging = true
					move_to_front()
			else:
				move_to_front()
				top_level = false
				release_focus()
				dragging = false

	elif event is InputEventMouseMotion:
		if dragging:
			var new_position = event.global_position - offset
			new_position.x = clamp(new_position.x, 0, get_viewport_rect().size.x - size.x)
			new_position.y = clamp(new_position.y, 0, get_viewport_rect().size.y - size.y)
			position = new_position
