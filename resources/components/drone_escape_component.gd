extends Node2D

@export var parent_node: Node2D

const escape_speed: int = 1000
var escape_direction: Vector2

var rng = RandomNumberGenerator.new()

func _ready():
	escape_direction = Vector2(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0)).normalized()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (parent_node.escaping):
		parent_node.look_at(escape_direction)
		parent_node.position += escape_direction * delta * escape_speed
