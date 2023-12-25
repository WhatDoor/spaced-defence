extends Area2D

const SPEED = 400;
var direction = null;
var damage = 1;
var penetration_chance = 1.0
var rng = RandomNumberGenerator.new()

func init(start_direction: Vector2, start_position: Vector2, bullet_penetration_chance):
	position = start_position
	look_at(start_direction)
	direction = start_direction
	position += direction * 10
	penetration_chance = bullet_penetration_chance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += (direction * SPEED * delta)
	
func destroy():
	if (rng.randf() <= penetration_chance):
		penetration_chance = penetration_chance/2 #halve the penetration chance for each successful penetration
	else:
		queue_free()
