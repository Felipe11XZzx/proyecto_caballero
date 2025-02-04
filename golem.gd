extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const projectile_scene = preload("res://arm_projectile.tscn")

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass
	#$movible/AnimatedSprite2D.play("idle_animation")

func _physics_process(delta: float) -> void:
	pass
	
func shot_projectile():
	$movible/Golem_sprite.play("throw_animation")
	var projectile = projectile_scene.instantiate()
	projectile.position.x = $movible/projectile_position.position.x
	projectile.position.y = $movible/projectile_position.position.y
	add_child(projectile)


func shot_laser():
	pass
	
func _on_timer_timeout() -> void:
	var rng = RandomNumberGenerator.new()
	var number = rng.randi_range(1, 3)
	
	if (number == 1):
		$AnimationPlayer.play("shoot_laser_projectile")
	
	if (number == 2):
		$AnimationPlayer.play("meele_animation")
		
	if (number == 3):
		$AnimationPlayer.play("shoot_projectile_animation")
		
	$Timer.wait_time = number
	$Timer.start()
