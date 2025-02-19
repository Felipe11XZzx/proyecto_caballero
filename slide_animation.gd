extends "res://knigth_state.gd"

func enter_state():
	pass

func process_state():
	animation_player.play("slide_animation")
	var direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_pressed("move_slide") && direction:
		knigth_machine_state.change_state($".")
		knigth.move_and_slide()
		
	if not Input.is_action_pressed("move_slide"):
		knigth_machine_state.change_state($"../idle_state")

func exit_state():
	pass
