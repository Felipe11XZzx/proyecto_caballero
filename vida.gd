class_name health_component extends Control

@export var max_health: float
@export var parent: Node2D
@export var health:  float
signal died

func update_bar_life():
	$barra_vida.value=health
	
func regene_health(healing : float):
	health += healing
	health=min(health + healing, max_health)
	update_bar_life()
	
func get_damage(damage : float):
	health -= damage
	update_bar_life()
	if health <= 0:
		died.emit()
		parent.queue_free()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$barra_vida.max_value=max_health
	$barra_vida.value=health
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
