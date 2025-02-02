extends "res://knigth_state.gd"

var current_state : knigth_state

func enter_state():
	pass
		
func process_state():
	var direction = Input.get_axis("move_left", "move_right")
	animation_player.play("idle_animation")
	
	if Input.is_action_pressed("move_jump") and knigth.is_on_floor():
		knigth_machine_state.change_state($"../jump_state")	
		
	elif Input.is_action_pressed("move_attack"):
		knigth_machine_state.change_state($"../attack_state")
	
	elif Input.is_action_pressed("move_attack_2"):
		knigth_machine_state.change_state($"../attack_2_state")
			
	elif Input.is_action_pressed("move_crouch"):
		knigth_machine_state.change_state($"../crouch_state")
			
					
	elif direction: 
		knigth_machine_state.change_state($"../run_state")
		
	elif not direction:
		knigth_machine_state.change_state($".")
	
func exit_state():
	pass
