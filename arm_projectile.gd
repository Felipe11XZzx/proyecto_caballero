extends Area2D

const proyectile_speed = 300

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	$".".position.x += proyectile_speed * delta
	pass
