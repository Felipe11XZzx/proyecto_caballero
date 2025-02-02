extends "res://knigth_state.gd"

@export var is_attacking = false

func enter_state():
	animation_player.play("attack_animation")
	is_attacking = false

func _process_state():
	if is_attacking:
		if Input.is_action_pressed("move_attack"):
			knigth_machine_state.chage_state($"../attack_2_state")
		else:
			knigth_machine_state.chage_state($"../idle_state")
	pass

func exit_state():
	pass
