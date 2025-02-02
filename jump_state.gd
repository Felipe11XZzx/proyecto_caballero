extends "res://knigth_state.gd"

func enter_state():
	animation_player.play("jump_animation")
	knigth.velocity.y = JUMP_VELOCITY
	knigth.move_and_slide()

func process_state():
	animation_player.play("jump_animation")
	var direction = Input.get_axis("move_left", "move_right")
	knigth.velocity.x = direction * SPEED

	
	if Input.is_action_pressed("move_jump"):
		print("Funciona saltar pero no cambia la animacion a idle")
		
		if direction != 0:
			knigth_machine_state.change_state($"../run_state")
		
		else:
			knigth_machine_state.change_state($"../idle_state")
			
	if not Input.is_action_pressed("move_jump") :
		print("Funciona cambio de estado de salto a idle")
		knigth_machine_state.change_state($"../idle_state")
			
	else:
		
		if knigth.velocity.x < 0:
			$"../../movible".scale.x = -abs($"../../movible".scale.x)
			knigth.move_and_slide()
						
		if knigth.velocity.x > 0:
			$"../../movible".scale.x = abs($"../../movible".scale.x)
			knigth.move_and_slide()				
			
func exit_state():
	pass
