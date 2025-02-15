extends Node

@export var speed: float = 100
@export var follow_distance: int = 160
@export var overshoot_limit: int = 2
# Añadir un contador similar
var exit_counter: int = 0
const EXIT_THRESHOLD: int = 10

@onready var parent: CharacterBody2D = get_parent()
var start_position: Vector2
var target_body: CharacterBody2D = null

func _ready() -> void:
	start_position = parent.global_position

func update_velocity():
	# Si estamos en el período de gracia de salida, seguimos persiguiendo la última posición conocida
	if exit_counter > 0:
		exit_counter -= 1
		if exit_counter == 0 and target_body == null:
			# Realmente se ha ido, volvemos a la posición inicial
			var dir_to_start = start_position - parent.global_position
			if dir_to_start.length() < overshoot_limit:
				parent.global_position = start_position
				parent.velocity = Vector2.ZERO
			else:
				parent.velocity = dir_to_start.normalized() * speed
		elif target_body != null:
			# El jugador volvió durante el período de gracia
			var direction = target_body.global_position - parent.global_position
			if (start_position - parent.global_position).length() > follow_distance:
				target_body = null
			else:
				parent.velocity = direction.normalized() * speed
	elif target_body:
		var direction = target_body.global_position - parent.global_position
		if (start_position - parent.global_position).length() > follow_distance:
			target_body = null
		else:
			parent.velocity = direction.normalized() * speed
	else:
		var dir_to_start = start_position - parent.global_position
		if dir_to_start.length() < overshoot_limit:
			parent.global_position = start_position
			parent.velocity = Vector2.ZERO
		else:
			parent.velocity = dir_to_start.normalized() * speed

func _physics_process(_delta: float) -> void:
	update_velocity()
	parent.move_and_slide()

func _on_detection_box_body_entered(body):
	if body.is_in_group("golem_damage"):
		target_body = body
		exit_counter = 0  # Resetear el contador

func _on_detection_box_body_exited(body):
	if body == target_body:
		exit_counter = EXIT_THRESHOLD  # Iniciar el contador
		# No ponemos target_body = null inmediatamente
		
		# Si no vuelve a entrar antes de que el contador llegue a cero,
		# entonces realmente se ha ido
		await get_tree().create_timer(0.5).timeout
		if exit_counter == 0:
			target_body = null
