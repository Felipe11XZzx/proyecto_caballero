extends "res://knigth_state.gd"

func enter_state():
	pass

func process_state():
	animation_player.play("run_animation")
	var direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_pressed("move_jump") and knigth.is_on_floor():
		knigth_machine_state.change_state($"../jump_state")	
		
	if Input.is_action_pressed("move_crouch"):
		knigth_machine_state.change_state($"../crouch_state")
		
	elif Input.is_action_pressed("move_attack"):
		knigth_machine_state.change_state($"../attack_state")
		
	elif not direction:
		knigth_machine_state.change_state($"../idle_state")
		
	else:
		knigth.velocity.x = direction * SPEED
		
		if knigth.velocity.x < 0:
			$"../../movible".scale.x = -abs($"../../movible".scale.x)
			knigth.move_and_slide()				
			
		if knigth.velocity.x > 0:
			$"../../movible".scale.x = abs($"../../movible".scale.x)
			knigth.move_and_slide()				
	
func exit_state():
	pass
	
