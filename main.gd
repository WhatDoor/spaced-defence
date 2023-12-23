extends Node2D

@onready var player = $Player;

var points = 0;

var rng = RandomNumberGenerator.new()
var spawn_radius = 330;

var bullet_template = preload("res://resources/player/bullet.tscn")

var enemies = {
	"basic": preload("res://resources/enemies/enemy.tscn"),
}

enum target_modes {MANUAL, NEAREST, STRONGEST}

var target_mode = target_modes.NEAREST

var currently_selected_target = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	#If not manually targetting, then need to regularly check if we are targetting the right one
	if (target_mode == target_modes.NEAREST):
		#calculate the closest enemy for the player
		var min_distance: float = -1;
		var closest_enemy: CharacterBody2D
		
		for enemy in $DetectionArea.get_overlapping_bodies():
			var enemy_distance = global_position.distance_to(enemy.global_position)
			
			if min_distance == -1:
				closest_enemy = enemy
				min_distance = enemy_distance
			
			if (enemy_distance < min_distance):
				closest_enemy = enemy
				min_distance = enemy_distance
				
		player.target_enemy = closest_enemy
		
		if (closest_enemy != currently_selected_target):
			#Record the selected enemy
			if currently_selected_target != null && is_instance_valid(currently_selected_target):
				currently_selected_target.deselected_as_target()
			closest_enemy.selected_as_target()
			currently_selected_target = closest_enemy

func _on_spawn_timer_timeout():
	var rand_x = rng.randf_range(-spawn_radius, spawn_radius);
	var rand_y = sqrt(spawn_radius**2 - rand_x**2);
	
	#50/50 chance of making rand_y positive or negative
	if (rng.randi_range(0, 1)):
		rand_y = rand_y * -1
		
	var enemy_node = enemies["basic"].instantiate()
	enemy_node.init(player, Vector2(rand_x, rand_y));
	call_deferred("add_child", enemy_node)

func _on_player_fire(bullet_direction: Vector2):
	var bullet_node = bullet_template.instantiate()
	bullet_node.init(bullet_direction);
	bullet_node.connect("enemy_hit", Callable(self, "handle_enemy_hit"))
	call_deferred("add_child", bullet_node)
	
func handle_enemy_hit(enemy: CharacterBody2D):
	points += 1
	enemy.queue_free()
