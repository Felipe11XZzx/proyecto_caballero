extends CharacterBody2D

const SPEED = 100.0
const fire_ball_scene = preload("res://fire_ball.tscn")

var direction = 1  
var can_change_direction = true 

func _ready() -> void:
	$AnimationPlayer.play("walk_worm_animation")  
	$Timer.start()

func _physics_process(delta: float) -> void:
	# Movimiento del gusano
	velocity.x = SPEED * direction
	move_and_slide()

	# Cambio de dirección con cooldown
	if can_change_direction and $detection_box_worm.has_overlapping_bodies():
		can_change_direction = false
		direction *= -1
		scale.x *= -1 
		$ChangeDirectionTimer.start() 

func shoot_fire_ball():
	$AnimationPlayer.play("attack_worm_animation")

	var fireball_worm = fire_ball_scene.instantiate()
	fireball_worm.global_position = $Movible/fireball_position.global_position
	
	if fireball_worm.has_method("set_direction"):
		fireball_worm.set_direction(direction)
	
	get_parent().add_child(fireball_worm)

func _on_timer_timeout() -> void:	
	shoot_fire_ball()

func _on_change_direction_timer_timeout() -> void:
	can_change_direction = true
	
func _on_hurtbox_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("golem_damage"):
		$CanvasLayer/Vida.get_damage(5)
