extends Node2D

signal enemy_hit(enemy: CharacterBody2D)

const SPEED = 400;
var direction = null;

func init(start_direction: Vector2):
	look_at(start_direction)
	direction = start_direction
	position += direction * 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += (direction * SPEED * delta)


func _on_area_2d_body_entered(enemy: CharacterBody2D):
	emit_signal("enemy_hit", enemy)
	queue_free()
