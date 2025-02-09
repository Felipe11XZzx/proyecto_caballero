extends "res://knigth_state.gd"

@export var is_attacking1 = false

func enter_state():
	animation_player.play("attack_animation")
	is_attacking1 = false
	
func process_state():
	if is_attacking1:
		if Input.is_action_pressed("move_attack"):
			knigth_machine_state.change_state($"../attack_2_state")
	
		else:
			knigth_machine_state.change_state($"../idle_state")
	
func exit_state():
	pass
