extends Node2D

var type: String = "attack_drone"
var active: bool = true
var escaping: bool = false
var tween: Tween
@onready var selfDestructTimer: Timer = $SelfDestructTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	tween = get_tree().create_tween()
	tween.set_loops() #loop infinitely
	tween.tween_property(self, "position", Vector2(0, 20), 1)
	tween.tween_property(self, "position", Vector2(0, -20), 1)

func run_away():
	tween.kill()
	escaping = true
	active = false
	selfDestructTimer.start()
	call_deferred("reparent", get_tree().current_scene)
