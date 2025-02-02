extends Node

var current_state : knigth_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_state = $idle_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_state.process_state()
	
func change_state(next_state: knigth_state):
	print("Exit: " + current_state.name)
	current_state.exit_state()
	current_state = next_state
	current_state.enter_state()
	print("Enter: " + current_state.name)
