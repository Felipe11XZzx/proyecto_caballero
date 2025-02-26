extends "res://knigth_state.gd"

@export var animation_finished = false

func enter_state():
	animation_finished = false
	
func process_state():
	animation_player.play("crouch_animation")
	var direction = Input.get_axis("move_left", "move_right")
	
	if animation_finished:
				
		if Input.is_action_pressed("move_crouch") && direction:
			knigth_machine_state.change_state($"../run_crawl_animation")
			
		if Input.is_action_pressed("move_crouch") and Input.is_action_pressed("move_attack"):
			knigth_machine_state.change_state($"../crawl_attack_state")
			
		if not Input.is_action_pressed("move_crouch"):
			knigth_machine_state.change_state($"../idle_state")
			
func exit_state():
	pass
