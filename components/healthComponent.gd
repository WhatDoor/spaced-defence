class_name HealthComponent extends Node

signal HP_changed(old: int, new: int)
signal Shield_changed(old: int, new: int)

@export var max_HP: int
@export var max_shield: int

var current_HP: int = 0
var current_Shield: int = 0

func _ready():
	current_HP = max_HP
	current_Shield = max_shield

func take_damage(damage):
	if (current_Shield != null && current_Shield > 0):
		var old_shield_value = current_Shield
		current_Shield -= damage 
		emit_signal("Shield_changed", old_shield_value, current_Shield)
	else:
		var old_HP_value = current_HP
		current_HP -= damage 
		emit_signal("HP_changed", old_HP_value, current_HP)
