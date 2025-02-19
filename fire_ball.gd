extends Area2D

@export var FIREBALL_SPEED = 300
var direction = 1 

func _process(delta: float) -> void:
	position.x += FIREBALL_SPEED * direction * delta

func set_direction(new_direction: int) -> void:
	direction = new_direction

func _on_timer_timeout() -> void:
	queue_free()
