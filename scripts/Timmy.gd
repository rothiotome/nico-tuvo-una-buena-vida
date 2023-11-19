extends Node

var current_stage: String
var current_age: int

var life_log: PackedStringArray

var effects: Dictionary

var partner_name: String

var events_file = "res://data/life_events.json"

var life_events: Array

signal fire_event(event: Dictionary)
signal add_item(id: String, desc: String)
signal remove_item(id: String)

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

func birthday(new_stage: String, new_age: int):
	current_stage = new_stage
	current_age = new_age
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
		if !effects.has(req): return false
		if effects[req] is float and effects[req] < required_effects[req]: return false
	return true
	
func on_response(button_pressed: Button):
	for effect in button_pressed.get_meta_list():
		var value = button_pressed.get_meta(effect)
		if value is float:
			if effects.has(effect):
				effects[effect] = effects[effect] + value
			else:
				effects[effect] = value
		else:
			if effect != "LOG":
				effects[effect] = value
				if value is bool:
					clear_item(effect)
				else:
					store_item(effect, value)
			else: life_log.append(value % current_age)

func store_item(id: String, desc: String):
	add_item.emit(id, desc)
	
func clear_item(id: String):
	effects.erase(id)
	remove_item.emit(id)

func life_expectancy_reached():
	life_log.append("Y moriste a la edad de %d años" % current_age)
	print(". ".join(life_log))
