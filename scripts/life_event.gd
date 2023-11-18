extends Resource

class_name LifeEvent

@export var id: String
@export var stages: Array[String]
@export var on_start: bool
@export_range(1,100) var yearly_chance: int
@export var required: Array[String]
@export var can_repeat: bool
@export var options: Array[EventOption]

var times_fired: int
