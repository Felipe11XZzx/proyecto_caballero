extends "res://knigth_state.gd"

var current_state : knigth_state
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = $"."
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_state
