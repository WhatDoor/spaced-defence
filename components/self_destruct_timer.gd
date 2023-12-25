extends Timer

@export var destroy_target: Node2D

func _on_timeout():
	destroy_target.queue_free()
