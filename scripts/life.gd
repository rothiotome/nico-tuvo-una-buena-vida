extends Control

@export var life_expectancy:float = 100
@export var year_duration: float = 1
var current_age:int = -1

var life_stages_order = ["Baby", "Child", "Teenager", "Young adult", "Adult", "Ancient"]

var life_stage: Dictionary = {
"Baby" : 0,
"Child": 5,
"Teenager": 12,
"Young adult": 20,
"Adult": 30,
"Ancient": 70
}

@onready var year_timer: Timer = %YearTimer
@onready var age_label: Label = %AgeLabel
@onready var stage_label: Label = %StageLabel
@onready var timmy: Timmy = %Timmy


func start_life():
	print("You are born!")
	year_timer.start(year_duration)
	
func on_max_life_expectancy_reached():
	pass

func _on_year_timeout():
	new_year()
	print("A year passed. Age %d" % current_age)

func new_year():
	current_age = current_age + 1
	var stage_check = check_stage_change(current_age)
	if stage_check["just_reached"]:
		print("You have just reached %s" % stage_check["stage"])
		
	age_label.text = str(current_age)
	stage_label.text = stage_check["stage"]
	timmy.birthday(stage_check["stage"], stage_check["just_reached"], current_age)

func get_current_stage():
	var current_stage = "Baby"
	for stage in life_stages_order:
		if current_age >= life_stage[stage]:
			current_stage = stage
	return current_stage
	
func check_stage_change(age: int) -> Dictionary:
	var result = {"just_reached": false, "stage": "Baby"}
  
	for stage in life_stages_order:
		if age >= life_stage[stage]:
			result["just_reached"] = (age == life_stage[stage])
			result["stage"] = stage
	return result
