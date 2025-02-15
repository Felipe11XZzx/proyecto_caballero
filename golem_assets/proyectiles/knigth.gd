class_name knigth_player extends CharacterBody2D


const SPEED = 800.0
const JUMP_VELOCITY = -800.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
func _on_knigtht_hurtbox_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("enemies"):
		$CanvasLayer/Vida.get_damage(25)
