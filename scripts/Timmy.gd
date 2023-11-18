extends Node

class_name Timmy

var current_stage: String

var health: int
var skills: Array
var preferences: Array

var events_folder = "res://resources/life_events/"

var life_events: Array[LifeEvent]

func _ready():
	load_events_from_folder(events_folder)
	
func load_events_from_folder(folder: String):
	
	var dir =  DirAccess.open(folder)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				life_events.append(load(folder + file_name))
				print("Add %s to life events array" % file_name)
				file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func birthday(new_stage: String, just_reached: bool, _current_age: int):
	current_stage = new_stage
	for event in life_events as Array[LifeEvent]:
		if !event.stages.has(current_stage): continue

		for required_skill in event.required:
			if !skills.has(required_skill): continue
		
		if event.on_start and !just_reached: continue
		
		if event.yearly_chance != 100:
			randomize()
			if randi() % 100  < event.yearly_chance:
				continue
		
		fire_event(event)
		
func fire_event(event: LifeEvent):
	if event.times_fired > 0 and !event.can_repeat:
		return
	
	event.times_fired = event.times_fired+1
	print(event.id)
	
