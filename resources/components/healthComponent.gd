extends Node2D

signal HP_changed(old: int, new: int)
signal shield_hit

@export var max_HP: int
@export var max_shield: int

var current_HP: int = 0
var current_Shield: int = 0

func _ready():
	current_HP = max_HP
	current_Shield = max_shield
	set_shields(current_Shield)
	
func _physics_process(delta):
	rotation = -get_parent().rotation

func set_shields(number_of_shields: int):
	var shield_counter = number_of_shields
	
	#first hide all shields
	for shield_child in get_children():
		shield_child.visible = false
	
	#now show the correct number
	while (shield_counter > 0):
		find_child("shield_" + str(shield_counter)).visible = true
		shield_counter -= 1
		
	current_Shield = number_of_shields

func take_damage(damage):
	if (current_Shield != null && current_Shield > 0):
		break_shield()
	else:
		var old_HP_value = current_HP
		current_HP -= damage 
		emit_signal("HP_changed", old_HP_value, current_HP)

func add_shield():
	if (current_Shield < 3):
		current_Shield += 1
		find_child("shield_" + str(current_Shield)).visible = true

func break_shield():
	if (current_Shield > 0):
		find_child("shield_" + str(current_Shield)).visible = false
		current_Shield -= 1
		emit_signal("shield_hit", current_Shield)
