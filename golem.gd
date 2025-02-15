extends CharacterBody2D

@export var is_laser_finished = false
@export var is_attacking = false
var activate = false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const projectile_scene = preload("res://arm_projectile.tscn")

func _ready() -> void:
	$movible/laser/laser_sprite.visible = false
	pass
	
func _process(delta: float) -> void:
	pass

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
	var is_playing = $AnimationPlayer.is_playing()
	$movible/laser/laser_sprite.visible = false

	#print("Animacion Aleatoria Numero: " + str(number))
	is_attacking = true
	if activate:
		if number == 1:
			$movible/laser/laser_sprite.visible = true
			$AnimationPlayer.play("shoot_laser_projectile")
			print("Entra en la animacion del laser")
			print("Sale de la animacion del laser\n")
	
		elif number == 2:
			print("Entra en la animacion meele")
			$AnimationPlayer.play("meele_animation")
			print("Sale de la animacion meele \n")

		elif number == 3:
			print("Sale de la animacion del proyectil ")
			$AnimationPlayer.play("shoot_projectile_animation")
			print("Sale de la animacion del proyectil \n")
		
	await $AnimationPlayer.animation_finished
	is_attacking = false
	
	var restartTime = rng.randi_range(2, 3)
	$Timer.wait_time = restartTime
	$Timer.start()
	
	
func _on_hurtbox_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("golem_damage"):
		$CanvasLayer/Vida.get_damage(15)


func _on_detection_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("golem_damage"):
		print("caballero detectado")
		activate = true


func _on_detection_box_body_exited(body: Node2D) -> void:
	if body.is_in_group("golem_damage"):
		$AnimationPlayer.play("idle_golem_animation")
		activate = false
		print("desactivando el area del golem")
