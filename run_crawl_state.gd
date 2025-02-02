extends "res://knigth_state.gd"


func enter_state():
	pass
	
func process_state():
	animation_player.play("run_crawl_animation")
	var direction = Input.get_axis("move_left", "move_right")
	print("no entra a la animacion corriendo agachado")
	
	if  Input.is_action_pressed("move_crouch"):
		print("entra a la animacion corriendo agachado")
		knigth.velocity.x = direction * SPEED

		if knigth.velocity.x < 0 and Input.is_action_pressed("move_left"):
			$"../../movible".scale.x = -abs($"../../movible".scale.x)	
			knigth.move_and_slide()
		
		if knigth.velocity.x > 0 and Input.is_action_pressed("move_right"):
			$"../../movible".scale.x = abs($"../../movible".scale.x)
			knigth.move_and_slide()
			
	if not Input.is_action_pressed("move_crouch"):
		knigth_machine_state.change_state($"../idle_state")
		
func exit_state():
	pass
