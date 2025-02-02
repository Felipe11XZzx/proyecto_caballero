class_name knigth_state extends Node

@onready var knigth: CharacterBody2D = $"../.."
@onready var animation_player: Node = $"../../AnimationPlayer"
@onready var knigth_machine_state: Node = $".."

const SPEED = 800.0
const JUMP_VELOCITY = -600.0

func enter_state():
	pass
	
func process_state():
	pass
	
func exit_state():
	pass
