extends "res://knigth_state.gd"

func enter_state():
	knigth.velocity.y = JUMP_VELOCITY
	knigth.move_and_slide()

func process_state():
	animation_player.play("jump_animation")
	var direction = Input.get_axis("move_left", "move_right")
	
	if 	knigth.is_on_floor():
		print("Funciona saltar pero no cambia la animacion a idle")
		
		if direction:
			knigth_machine_state.change_state($"../run_state")
		
		else:
			knigth_machine_state.change_state($"../idle_state")
						
	else:
		knigth.velocity.x = direction * SPEED

		if knigth.velocity.x < 0:
			$"../../movible".scale.x = -abs($"../../movible".scale.x)
						
		if knigth.velocity.x > 0:
			$"../../movible".scale.x = abs($"../../movible".scale.x)
			
	knigth.move_and_slide()							
			
func exit_state():
	pass
