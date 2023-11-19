extends Node

class_name Timmy

var current_stage: String

var life_log: String

var effects: Dictionary

var partner_name: String

var events_file = "res://data/life_events.json"

var life_events: Array

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
	for event in life_events:
		if !event["stages"].has(current_stage): continue
		for required_effect in event["required"]:
			var effect = effects.get(required_effect)
			if effect == null: continue
			if effects[effect] < event["required"][required_effect]: continue
		
		if event["yearly_chance"] < 100:
			randomize()
			if randi() % 100 < event["yearly_chance"]: continue
			
		fire_event(event)
		life_events.erase(event)
		break
		
func add_response()
		
func fire_event(event: Dictionary):
	
	print(event["text"])
	
