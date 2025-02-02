extends "res://knigth_state.gd"

func enter_state():
	pass
	
func process_state():
	animation_player.play("crawl_attack_animation")
	print("Cambia a la animacion atacar agachado")
	
	if Input.is_action_pressed("move_crouch") && Input.is_action_pressed("move_attack"):
		knigth_machine_state.change_state($".")
	
	else:
		knigth_machine_state.change_state($"../crouch_state")
	
func exit_state():
	pass
