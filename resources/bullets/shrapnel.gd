extends Area2D

enum shrapnel_types {LEFT, RIGHT}
var shrapnel_type: shrapnel_types 

@onready var timer = $SelfDestructTimer

var rng = RandomNumberGenerator.new()
var speed = 400;
var direction = null;
var rotation_speed = 0;
var duration = 0;

var damage = 1;

func init(type: shrapnel_types, starting_position: Vector2):
	shrapnel_type = type

	if shrapnel_type == shrapnel_types.LEFT:
		$left.visible = true
	elif shrapnel_type == shrapnel_types.RIGHT:
		$right.visible = true
	
	position = starting_position

	#randomly determine speed, rotation speed, direction and duration
	speed = rng.randi_range(0,400)
	direction = Vector2(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0))
	rotation_speed = rng.randi_range(-1200, 1200)
	duration = rng.randf_range(0, 3)

func _ready():
	timer.set_wait_time(duration)
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += (direction * speed * delta)
	rotation_degrees += rotation_speed * delta 

func _on_expiry_timer_timeout():
	queue_free()

func destroy():
	queue_free()
