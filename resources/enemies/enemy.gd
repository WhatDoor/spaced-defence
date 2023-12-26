extends CharacterBody2D

signal died(enemy: CharacterBody2D)

@export var target: CharacterBody2D = null;

@onready var deathAnim = $deathAnimation

const point_value = 1;
var SPEED: int = 2000;
const fracture_chance = 1.0;

func init(player_target: CharacterBody2D, starting_pos: Vector2):
	target = player_target;
	global_position = starting_pos
	look_at(target.global_position);

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	var move_dir = global_position.direction_to(target.global_position);
	velocity = SPEED * delta * move_dir;
	
	move_and_slide();

func selected_as_target():
	$target_indicator.visible = true
	$target_indicator.rotation -= rotation
	
func deselected_as_target():
	$target_indicator.visible = false

func _on_health_component_hp_changed(old, new):
	if (new <= 0):
		SPEED = 0
		$Sprite2D.visible = false
		deathAnim.visible = true
		$HurtboxComponent.set_deferred("monitoring", false) #prevent ship from dying over and over
		$CollisionShape2D.set_deferred("disabled", true) #indicates to world that this is no longer a valid target
		deathAnim.play("default")
		emit_signal("died", self)

func _on_death_animation_animation_finished():
	queue_free()
