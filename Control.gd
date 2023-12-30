extends Control

signal upgrade_purchased(upgrade_name: String)
signal consumable_purchased(consumable: String)

@onready var points_label = $MarginContainer/VBoxContainer/Label

@onready var BlasterUpgradeContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/BlasterUpgradeContainer
@onready var ThrusterUpgradeContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/ThrusterUpgradeContainer
@onready var HighDensityAmmoContainer = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/HighDensityAmmoContainer
@onready var EnemyFractureChanceContainer = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/EnemyFractureChanceContainer

@export var points = 0

var upgrade_data = {
	"blaster_upgrade": {
		"current_level": 1,
		"label": "Blaster Upgrade\n",
		"cost_per_level": {
			2: 100,
			3: 200,
			4: 300,
			5: 400,
			6: 500,
			7: 600,
			8: 700,
			9: 800,
			10: 900,
		}
	},
	"thrusters_upgrade": {
		"current_level": 1,
		"label": "Thruster Upgrade\n",
		"cost_per_level": {
			2: 100,
			3: 100,
			4: 100,
			5: 100,
			6: 100,
			7: 100,
			8: 100,
			9: 100,
			10: 100,
		}
	},
	"high_density_ammo": {
		"current_level": 1,
		"label": "High Density Ammo\n",
		"cost_per_level": {
			2: 100,
			3: 100,
			4: 100,
			5: 100,
			6: 100,
			7: 100,
			8: 100,
			9: 100,
			10: 100,
		}
	},
	"enemy_fracture_chance": {
		"current_level": 1,
		"label": "Precision Firing\n",
		"cost_per_level": {
			2: 100,
			3: 100,
			4: 100,
			5: 100,
			6: 100,
			7: 100,
			8: 100,
			9: 100,
			10: 100,
		}
	}
}

var consumable_costs = {
	"shields": {
		"label": "Shields\n",
		"cost_per_level": {
			0: 500,
			1: 600,
			2: 700,
		}
	},
	"attack_drone": {
		"label": "Attack Drone\n",
		"cost_per_level": {
			0: 500,
			1: 600,
			2: 700,
			3: 700,
			4: 700,
		}
	},
	"gravity_drone": {
		"label": "Gravity Drone\n",
		"cost_per_level": {
			0: 500,
			1: 600,
			2: 700,
			3: 700,
			4: 700,
		}
	},
	"cash_drone": {
		"label": "Cash Drone\n",
		"cost_per_level": {
			0: 500,
			1: 600,
			2: 700,
			3: 700,
			4: 700,
		}
	}
}

func add_points(add_amount: int):
	points += add_amount
	points_label.set_text("Points: " + str(points))

func buy_upgrade_if_possible(upgrade_name: String):
	var single_upgrade_data = upgrade_data[upgrade_name]
	var next_level_cost = single_upgrade_data.cost_per_level.get(single_upgrade_data.current_level + 1)
	
	if next_level_cost != null && points >= next_level_cost:
		points -= next_level_cost
		single_upgrade_data.current_level = single_upgrade_data.current_level + 1
		emit_signal("upgrade_purchased", upgrade_name)

func update_upgrade_ui(container: Control, upgrade_name):
	var single_upgrade_data = upgrade_data[upgrade_name]
	
	#Update progress bar
	container.find_child("ProgressBar").value = single_upgrade_data.current_level
	
	var next_level_cost = single_upgrade_data.cost_per_level.get(single_upgrade_data.current_level + 1)
	
	#Update button text
	if (next_level_cost != null):
		container.find_child(upgrade_name).text = single_upgrade_data.label + str(next_level_cost)
	else:
		container.find_child(upgrade_name).text = single_upgrade_data.label + "MAXED"
		container.find_child(upgrade_name).disabled = true
	
	#Update points text
	points_label.set_text("Points: " + str(points))

func _on_blaster_upgrade_label_pressed():
	buy_upgrade_if_possible("blaster_upgrade")
	update_upgrade_ui(BlasterUpgradeContainer, "blaster_upgrade")

func _on_thrusther_upgrade_label_pressed():
	buy_upgrade_if_possible("thrusters_upgrade")
	update_upgrade_ui(ThrusterUpgradeContainer, "thrusters_upgrade")

func _on_high_density_ammo_pressed():
	buy_upgrade_if_possible("high_density_ammo")
	update_upgrade_ui(HighDensityAmmoContainer, "high_density_ammo")

func _on_enemy_fracture_chance_pressed():
	buy_upgrade_if_possible("enemy_fracture_chance")
	update_upgrade_ui(EnemyFractureChanceContainer, "enemy_fracture_chance")

func consumable_purchase_confirmed(consumable: String, new_consumable_value: int):
	var container = find_child(consumable + "Container")
	var current_level = container.find_child("ProgressBar").value
	points -= consumable_costs[consumable].cost_per_level[int(current_level)]
	container.find_child("ProgressBar").value = new_consumable_value

	#Update points text
	points_label.set_text("Points: " + str(points))

	#Update buttons text
	var next_level_cost = consumable_costs[consumable].cost_per_level.get(int(current_level + 1))
	if (next_level_cost != null):
		container.find_child(consumable).text = consumable_costs[consumable].label + str(next_level_cost)
	else:
		container.find_child(consumable).text = consumable_costs[consumable].label + "MAXED"
		container.find_child(consumable).disabled = true

func drone_purchase_confirmed(drone_type: String, new_drone_count: int):
	var container = find_child("dronesContainer")
	var current_level = container.find_child("ProgressBar").value
	points -= consumable_costs[drone_type].cost_per_level[int(current_level)]
	container.find_child("ProgressBar").value = new_drone_count

	#Update points text
	points_label.set_text("Points: " + str(points))

	#Update buttons text
	var next_level_cost = consumable_costs[drone_type].cost_per_level.get(int(current_level + 1))
	if (next_level_cost != null):
		container.find_child(drone_type).text = consumable_costs[drone_type].label + str(next_level_cost)
	else:
		container.find_child(drone_type).text = consumable_costs[drone_type].label + "MAXED"
		container.find_child(drone_type).disabled = true

func _on_buy_shields_pressed():
	var current_level = find_child("shieldsContainer").find_child("ProgressBar").value
	var price = consumable_costs["shields"].cost_per_level.get(int(current_level))
	
	if price != null && points >= price:
		emit_signal("consumable_purchased", "shields")

func _on_buy_attack_drone_pressed():
	var current_level = find_child("dronesContainer").find_child("ProgressBar").value
	var price = consumable_costs["attack_drone"].cost_per_level.get(int(current_level))

	if price != null && points >= price:
		emit_signal("consumable_purchased", "attack_drone")

func update_shield_val(new_shield_val: int):
	find_child("shieldsContainer").find_child("ProgressBar").value = new_shield_val

func clear_drones():
	find_child("dronesContainer").find_child("ProgressBar").value = 0
