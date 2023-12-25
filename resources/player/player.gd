extends CharacterBody2D

signal fire(bullet_direction: Vector2)

var rotation_speed = 1200 #degrees per second
const attack_speed = 1.0 #attacks per second

var attack_speed_reset = 1/attack_speed
var counter_to_attack = 0
var ready_to_fire = false

var target_enemy = null

func _physics_process(delta):
	counter_to_attack += delta
	
	#only attack every time the counter to attack fills up
	if (counter_to_attack >= attack_speed_reset && ready_to_fire):
		counter_to_attack -= attack_speed_reset
		var bullet_direction = to_global(Vector2(1, 0)).normalized() #shoot forwards, wherever that is
		emit_signal("fire", bullet_direction)

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
	pass