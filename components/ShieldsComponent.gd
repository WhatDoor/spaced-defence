extends Node2D

@export var starting_shields: int = 0
var current_shields: int = 0

func _ready():
	set_shields(starting_shields)

func set_shields(number_of_shields: int):
	var shield_counter = number_of_shields
	
	#first hide all shields
	for shield_child in get_children():
		shield_child.visible = false
	
	#now show the correct number
	while (shield_counter > 0):
		find_child("shield_" + str(shield_counter)).visible = true
		shield_counter -= 1
		
	current_shields = number_of_shields

func add_shield():
	if (current_shields < 3):
		current_shields += 1
		find_child("shield_" + str(current_shields)).visible = true

func break_shield():
	if (current_shields > 0):
		find_child("shield_" + str(current_shields)).visible = false
		current_shields -= 1
