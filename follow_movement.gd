extends Node

@export var speed: float = 200
@export var follow_distance: int = 500
@export var overshoot_limit: int = 5
var exit_counter: int = 10
const EXIT_THRESHOLD: int = 20

@onready var parent: CharacterBody2D = get_parent()
var start_position: Vector2
var target_body: CharacterBody2D = null

func _ready() -> void:
	start_position = parent.global_position

func update_velocity():
	if exit_counter > 0:
		exit_counter -= 1
		if exit_counter == 0 and target_body == null:
			var dir_to_start = start_position - parent.global_position
			dir_to_start.y = 0  
			
			if dir_to_start.length() < overshoot_limit:
				parent.global_position.x = start_position.x
				parent.velocity = Vector2.ZERO
			else:
				parent.velocity = dir_to_start.normalized() * speed
		elif target_body != null:
			var direction = target_body.global_position - parent.global_position
			var horizontal_distance = abs(target_body.global_position.x - start_position.x)
			
			if horizontal_distance > follow_distance:
				target_body = null
			else:
				direction.y = 0  
				parent.velocity = direction.normalized() * speed
	elif target_body:
		var direction = target_body.global_position - parent.global_position
		var horizontal_distance = abs(target_body.global_position.x - start_position.x)
		
		if horizontal_distance > follow_distance:
			target_body = null
		else:
			direction.y = 0  
			parent.velocity = direction.normalized() * speed
	else:
		var dir_to_start = start_position - parent.global_position
		dir_to_start.y = 0  
		
		if dir_to_start.length() < overshoot_limit:
			parent.global_position.x = start_position.x
			parent.velocity = Vector2.ZERO
		else:
			parent.velocity = dir_to_start.normalized() * speed

func _physics_process(_delta: float) -> void:
	if not parent.is_attacking:
		update_velocity()
		parent.move_and_slide()

func _on_detection_box_body_entered(body):
	if body.is_in_group("golem_damage"):
		target_body = body as CharacterBody2D  
		exit_counter = 0  

func _on_detection_box_body_exited(body):
	if body == target_body:
		exit_counter = EXIT_THRESHOLD  
		
		await get_tree().create_timer(0.5).timeout
		if exit_counter == 0 and not parent.detection_area.has_overlapping_bodies():
			target_body = null
