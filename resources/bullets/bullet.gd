extends Node2D

const SPEED = 400;
var direction = null;
var damage = 1;

func init(start_direction: Vector2, start_position: Vector2):
	position = start_position
	look_at(start_direction)
	direction = start_direction
	position += direction * 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += (direction * SPEED * delta)
