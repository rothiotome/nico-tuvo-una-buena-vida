extends Control

@export var life_expectancy:float = 100
@export var year_duration: float = 1
var current_age:int = -1

@export var popup_event_node: PackedScene
@export var popup_item_node: PackedScene

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

var inventory: Dictionary = {}

func start_life():
	print("¡Has nacido!")
	year_timer.start(year_duration)
	Timmy.fire_event.connect(fire_event)
	Timmy.add_item.connect(add_item)
	Timmy.remove_item.connect(remove_item)
	Timmy.die.connect(year_timer.stop)
	
func on_max_life_expectancy_reached():
	Timmy.life_expectancy_reached()

func _on_year_timeout():
	new_year()
	print("Ha pasado un año. Edad %d" % current_age)
	if current_age >= life_expectancy:
		year_timer.stop()
		on_max_life_expectancy_reached()
		
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
	var panel = popup_event_node.instantiate() as EventPopup
	panel.initialize(event)
	add_and_move_child(panel)
	

func add_item(id: String, desc: String):
	var item = popup_item_node.instantiate() as ItemPopup
	item.initialize(desc)
	inventory[id] = item
	add_and_move_child(item)
	
func remove_item(id: String):
	inventory[id].queue_free()
	inventory.erase(id)
	
func add_and_move_child(node: BasePopup):
	add_child(node)
	await get_tree().process_frame
	var node_size = node.get_size()
	var screen_size = get_viewport().get_visible_rect().size
	randomize()
	var random_position = Vector2(
		floorf(randi_range(0, screen_size.x - node_size.x)),
		floorf(randi_range(0, screen_size.y - node_size.y)))
	node.set_position(random_position)
