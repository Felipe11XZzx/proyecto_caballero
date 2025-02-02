extends "res://knigth_state.gd"

@export var is_attacking = false

func enter_state():
	is_attacking = false
	animation_player.play("attack_animation")
	print("entra en la animacion 1 de ataque")
	
func process_state():
	if Input.is_action_pressed("move_attack"):
		print("Entra en el ataque 1")
		knigth_machine_state.change_state($".")
	else:
		knigth_machine_state.change_state($"../idle_state")
	
func exit_state():
	pass
