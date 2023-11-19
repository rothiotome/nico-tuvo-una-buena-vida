extends BasePopup

class_name ItemPopup

var item

@onready var window = $MarginContainer/Window

func initialize(new_item):
	item = new_item
	
func _ready():
	var message = message_node.instantiate() as Label
	
	message.text = item
	window.add_child(message)
