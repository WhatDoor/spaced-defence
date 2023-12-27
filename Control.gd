extends Control

signal upgrade_purchased(upgrade_name: String)
signal consumable_purchased(consumable: String)

@onready var points_label = $MarginContainer/VBoxContainer/Label

@onready var BlasterUpgradeContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/BlasterUpgradeContainer
@onready var ThrusterUpgradeContainer = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/MarginContainer/ThrusterUpgradeContainer
@onready var HighDensityAmmoContainer = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/HighDensityAmmoContainer
@onready var EnemyFractureChanceContainer = $MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/MarginContainer/EnemyFractureChanceContainer

var points = 0

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
	"shields": 1, 
	"drones": 1,
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

func buy_consumable(consumable: String):
	if points >= consumable_costs[consumable]:
		emit_signal("consumable_purchased", consumable)

func consumable_purchase_confirmed(consumable: String, new_consumable_value: int):
	find_child(consumable + "Container").find_child("ProgressBar").value = new_consumable_value
