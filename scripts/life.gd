extends Control

@export var life_expectancy:float = 100
@export var year_duration: float = 1
var current_age:int = -1

@export var popup_panel_node: PackedScene

var life_stages_order = ["Bebé", "Niño", "Adolescente", "Joven Adulto", "Adulto", "Anciano"]

var life_stage: Dictionary = {
"Bebé" : 0,
"Niño": 5,
"Adolescente": 12,
"Joven Adulto": 20,
"Adulto": 30,
"Anciano": 70
}

@onready var year_timer: Timer = %YearTimer
@onready var age_label: Label = %AgeLabel
@onready var stage_label: Label = %StageLabel

func start_life():
	print("¡Has nacido!")
	year_timer.start(year_duration)
	Timmy.fire_event.connect(fire_event)
	
func on_max_life_expectancy_reached():
	pass

func _on_year_timeout():
	new_year()
	print("Ha pasado un año. Edad %d" % current_age)

func new_year():
	current_age = current_age + 1
	var stage_check = check_stage_change(current_age)
	if stage_check["just_reached"]:
		print("Te has convertido en un %s" % stage_check["stage"])
		
	age_label.text = str(current_age)
	stage_label.text = stage_check["stage"]
	Timmy.birthday(stage_check["stage"], current_age)

func get_current_stage():
	var current_stage = "Bebé"
	for stage in life_stages_order:
		if current_age >= life_stage[stage]:
			current_stage = stage
	return current_stage
	
func check_stage_change(age: int) -> Dictionary:
	var result = {"just_reached": false, "stage": "Bebé"}
  
	for stage in life_stages_order:
		if age >= life_stage[stage]:
			result["just_reached"] = (age == life_stage[stage])
			result["stage"] = stage
	return result

func fire_event(event: Dictionary):
	var panel = popup_panel_node.instantiate() as EventPopup
	panel.initialize(event)
	add_child(panel)
	await get_tree().process_frame
	var panel_size = panel.get_size()
	var screen_size = get_viewport().get_visible_rect().size
	randomize()
	var random_position = Vector2(
		floorf(randi_range(0, screen_size.x - panel_size.x)),
		floorf(randi_range(0, screen_size.y - panel_size.y)))
	panel.set_position(random_position)
