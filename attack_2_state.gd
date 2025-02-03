extends "res://knigth_state.gd"

@export var is_attacking2 = false

func enter_state():
	animation_player.play("attack_2_animation")
	is_attacking2 = false
	print("entra en la animacion 2 de ataque")
	
func process_state():
	if is_attacking2:
		if Input.is_action_pressed("move_attack"):
			print("Entra en el ataque 2")
			knigth_machine_state.change_state($"../attack_state")
			
		else:
			knigth_machine_state.change_state($"../idle_state")
	
func exit_state():
	pass
