extends Control

signal upgrade_purchased(upgrade_name: String)

@onready var points_label = $MarginContainer/VBoxContainer/Label

var points = 0

var costs = {
	"blaster_upgrade": 100,
	"thruster_upgrade": 100,
}

func add_points(add_amount: int):
	points += add_amount
	points_label.set_text("Points: " + str(points))

func buy_if_possible(upgrade_name: String):
	if points >= costs[upgrade_name]:
		points -= costs[upgrade_name]
		emit_signal("upgrade_purchased", upgrade_name)
		print("purchased " + upgrade_name)

func _on_blaster_upgrade_label_pressed():
	buy_if_possible("blaster_upgrade")

#i love you hunny
