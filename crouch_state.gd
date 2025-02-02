extends "res://knigth_state.gd"

@export var animation_finished = false

func enter_state():
	animation_finished = false
	
func process_state():
	animation_player.play("crouch_animation")
	var direction = Input.get_axis("move_left", "move_right")
	print("animation finish false")
	
	if animation_finished:
		print("animation finish true")
				
		if Input.is_action_pressed("move_crouch") && direction:
			knigth_machine_state.change_state($"../run_crawl_animation")
			
		if not Input.is_action_pressed("move_crouch"):
			knigth_machine_state.change_state($"../idle_state")
				
		if knigth.velocity.x < 0:
			$"../../movible".scale.x =  -abs($"../../movible".scale.x)	
			knigth.move_and_slide()				
			
		if knigth.velocity.x > 0:
			$"../../movible".scale.x =abs($"../../movible".scale.x)
			knigth.move_and_slide()				
			
func exit_state():
	pass
