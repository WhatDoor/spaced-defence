class_name HurtboxComponent extends Area2D

@export var healthComponent: Node2D = null

func _on_area_entered(bullet):
	healthComponent.take_damage(bullet.damage)
	bullet.destroy()

func _on_body_entered(enemy):
	healthComponent.take_damage(1)
	enemy.queue_free()
