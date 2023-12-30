extends CharacterBody2D

signal fire(bullet_direction: Vector2, bullet_penetration_chance: float)
signal shield_hit(new_shield_val: int)

@onready var HPComponent = $HealthComponent

var rotation_speed = 180 #degrees per second
var attack_speed = 1.0 #attacks per second

var attack_speed_reset = 1/attack_speed
var counter_to_attack = 0
var ready_to_fire = false

var bullet_penetration_chance = 0.1
var enemy_fracture_chance = 0.1

var target_enemy = null

var drones_preloads = {
	"attack_drone": preload("res://resources/player/attack_drone.tscn"), 
	"gravity_drone": preload("res://resources/player/attack_drone.tscn"), 
	"cash_drone": preload("res://resources/player/attack_drone.tscn"), 
}
var drones = []

func _physics_process(delta):
	counter_to_attack += delta
	
	#only attack every time the counter to attack fills up
	if (counter_to_attack >= attack_speed_reset && ready_to_fire):
		counter_to_attack -= attack_speed_reset
		var bullet_direction = to_global(Vector2(1, 0)).normalized() #shoot forwards, wherever that is
		emit_signal("fire", bullet_direction, position, bullet_penetration_chance)

		for drone in drones:
			if drone.active && drone.type == "attack_drone":
				emit_signal("fire", bullet_direction, to_global(drone.position), bullet_penetration_chance)

	#Even if we can't shoot for some time, keep the counter clamped at the max amount
	counter_to_attack = clampf(counter_to_attack, 0, attack_speed_reset)
	
	if (self.target_enemy != null):
		var angle_to_target = rad_to_deg(get_angle_to(target_enemy.global_position))
		var rotation_speed_per_frame = rotation_speed * delta
		if (abs(angle_to_target) < rotation_speed_per_frame):
			rotation_degrees += angle_to_target
			ready_to_fire = true
		else:
			ready_to_fire = false
			if (angle_to_target > 0):
				rotation_degrees += rotation_speed_per_frame
			else:
				rotation_degrees -= rotation_speed_per_frame

func upgrade_purchased(upgrade_name: String):
	match (upgrade_name):
		"blaster_upgrade":
			attack_speed += 1.0
			attack_speed_reset = 1/attack_speed
		"thrusters_upgrade":
			rotation_speed += 100
		"high_density_ammo":
			bullet_penetration_chance += 0.2
		"enemy_fracture_chance":
			enemy_fracture_chance += 0.1
		_:
			print("unknown upgrade purchased")

func buy_consumable(consumable: String):
	match (consumable):
		"shields":
			if HPComponent.current_Shield < 3:
				HPComponent.add_shield()
				return HPComponent.current_Shield
		"attack_drone":
			if drones.size() < 5:
				add_drone("attack_drone")
				return drones.size()
		_:
			print("unknown consumable purchased")
			return null

func add_drone(drone_name: String):
	var new_drone = drones_preloads[drone_name].instantiate()
	drones.append(new_drone)
	$DroneAnchor.add_child(new_drone)	

func _on_health_component_hp_changed(_old, new):
	if (new == 0):
		queue_free() #ded
		get_tree().paused = true

func _on_health_component_shield_hit(new_shield_val):
	for drone in drones:
		drone.run_away()
	emit_signal("shield_hit", new_shield_val)
	
