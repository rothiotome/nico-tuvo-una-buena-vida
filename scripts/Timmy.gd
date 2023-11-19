extends Node

var current_stage: String

var life_log: String

var effects: Dictionary

var partner_name: String

var events_file = "res://data/life_events.json"

var life_events: Array

var popup_panel_node = preload("res://nodes/panel.tscn")

signal fire_event(event: Dictionary)

func _ready():
	life_events = load_events_from_file(events_file)
	for n in life_events:
		print("Added: %s to life events" % n["text"])
	
func load_events_from_file(file_path: String):
	if FileAccess.file_exists(file_path):
		var file =  FileAccess.open(file_path, FileAccess.READ)
		var content_as_text = file.get_as_text()
		var parsed_result = JSON.parse_string(content_as_text)
		
		if parsed_result is Array:
			return parsed_result
		else:
			print("Error reading file %s" % file_path)
	else:
		print("An error occurred when trying to open the file %s" % file_path)

func birthday(new_stage: String, _current_age: int):
	current_stage = new_stage
	for event in life_events as Array:
		if !event["stages"].has(current_stage): continue
		if !has_required(event["required"]): continue
		
		if event["yearly_chance"] < 100:
			randomize()
			if randi() % 100 < event["yearly_chance"]: continue
			
		fire_event.emit(event)
		life_events.erase(event)
		return
		
func has_required(required_effects: Dictionary) -> bool:
	for req in required_effects:
		var effect = effects.get(req)
		if effect == null: return false
		if effects[req] < required_effects[req]: return false
	return true
	
func on_response(button_pressed: Button):
	print(button_pressed.text)
	for effect in button_pressed.get_meta_list():
		if effects.has(effect) and effects[effect] is int:
			effects[effect] = effects[effect] + button_pressed.get_meta(effect)
		else:
			effects[effect] = button_pressed.get_meta(effect)
