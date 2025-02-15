extends CharacterBody2D

@export var is_attacking: bool = false
var activate: bool = false
const ATTACK_RANGE: float = 50.0
# Añadir un contador para ignorar salidas rápidas
var exit_counter: int = 0
const EXIT_THRESHOLD: int = 10

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var follow_movement: Node = $FollowMovementC
@onready var detection_area: Area2D = $detection_box
@onready var sprite: AnimatedSprite2D = $movible/skeletonSprite
@onready var attack_timer: Timer = $AttackTimer

var player: CharacterBody2D = null

func _ready() -> void:
	print("Skeleton ready")
	
	# Verificar que los nodos existan
	if !has_node("detection_box"):
		print("ERROR: detection_box node not found!")
		return
	if !has_node("AnimationPlayer"):
		print("ERROR: AnimationPlayer node not found!")
	if !has_node("FollowMovementC"):
		print("ERROR: FollowMovementC node not found!")
	if !has_node("movible/skeletonSprite"):
		print("ERROR: movible/skeletonSprite node not found!")
	if !has_node("AttackTimer"):
		print("ERROR: AttackTimer node not found!")
	
	print("All nodes found")
	print("detection_area monitoring: ", detection_area.monitoring)
	print("detection_area monitorable: ", detection_area.monitorable)
	
	# Asegúrate de que el monitoring esté habilitado
	detection_area.monitoring = true
	
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	attack_timer.start(randf_range(2, 5))
	
	# Verificar conexiones
	var connections = detection_area.get_signal_connection_list("body_entered")
	print("body_entered connections: ", connections)

func _physics_process(_delta: float) -> void:
	# Si el jugador salió recientemente pero aún no ha pasado el umbral, decrementar contador
	if exit_counter > 0:
		exit_counter -= 1
		# Si el contador llega a cero, entonces realmente consideramos que el jugador se fue
		if exit_counter == 0 and player == null:
			animation_player.play("idle_skeleton_animation")
	
	if player and global_position.distance_to(player.global_position) < ATTACK_RANGE and not is_attacking:
		_attack()
	elif not is_attacking and player:
		animation_player.play("walk_skeleton_animation")
	elif not player and not is_attacking and exit_counter == 0:
		animation_player.play("idle_skeleton_animation")

func _on_body_entered(body: Node2D) -> void:
	print("Body entered: ", body.name)
	print("Body groups: ", body.get_groups())
	
	if body.is_in_group("golem_damage"):
		print("Player detected!")
		player = body
		activate = true
		exit_counter = 0  # Resetear el contador de salida
		follow_movement._on_detection_box_body_entered(body)

func _on_body_exited(body: Node2D) -> void:
	print("Body exited: ", body.name)
	
	if body == player:
		print("Player exited")
		exit_counter = EXIT_THRESHOLD  # Iniciar el contador en lugar de inmediatamente poner player a null
		activate = false
		
		# No cambiamos player = null inmediatamente
		# No llamamos a idle_skeleton_animation inmediatamente
		
		# Todavía notificamos al componente de movimiento
		follow_movement._on_detection_box_body_exited(body)
		
		# Solo si no vuelve a entrar antes de que el contador llegue a cero,
		# entonces realmente consideraremos que se ha ido
		await get_tree().create_timer(0.5).timeout
		if exit_counter == 0:
			player = null

func _attack() -> void:
	is_attacking = true
	velocity.x = 0
	animation_player.play("attack_skeleton_animation")
	await animation_player.animation_finished
	is_attacking = false
	attack_timer.start(randf_range(2, 5))

func _on_attack_timer_timeout() -> void:
	if player and global_position.distance_to(player.global_position) < ATTACK_RANGE and not is_attacking:
		_attack()
