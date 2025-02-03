extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const projectile_scene = preload("res://arm_projectile.tscn")

func _ready() -> void:
	$movible/AnimatedSprite2D.play("throw_animation")
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
	projectile.position.x = $movible/projectile_position.position.x
	projectile.position.y = $movible/projectile_position.position.y
	
func _process(delta: float) -> void:
	pass
	#$movible/AnimatedSprite2D.play("idle_animation")

func _physics_process(delta: float) -> void:
	pass
