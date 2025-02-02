extends "res://knigth_state.gd"


func enter_state():
	animation_player.play("attack_2_animation")
	print("entra en la animacion 2 de ataque")
	
func process_state():
	if Input.is_action_pressed("move_attack_2"):
		print("Entra en el ataque 2")
		knigth_machine_state.change_state($".")
	else:
		knigth_machine_state.change_state($"../idle_state")
	
func exit_state():
	pass
