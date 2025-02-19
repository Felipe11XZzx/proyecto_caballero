extends CharacterBody2D

@export var is_attacking: bool = false
var activate: bool = false
const ATTACK_RANGE: float = 50.0
const EXIT_THRESHOLD: int = 10
const PATROL_SPEED: float = 30.0
const CHASE_SPEED: float = 100.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var detection_area: Area2D = $detection_box
@onready var sprite: AnimatedSprite2D = $movible/skeletonSprite
@onready var attack_timer: Timer = $AttackTimer
@onready var patrol_timer: Timer = $PatrolTimer

var player: CharacterBody2D = null
var exit_counter: int = 0
var patrol_direction: int = 1

func _ready() -> void:
	print("Skeleton ready")
	detection_area.body_entered.connect(_on_body_entered)
	detection_area.body_exited.connect(_on_body_exited)
	attack_timer.timeout.connect(_on_attack_timer_timeout)
	patrol_timer.timeout.connect(_on_patrol_timer_timeout)

	attack_timer.wait_time = randf_range(2.0, 3.0)
	attack_timer.start()
	patrol_timer.wait_time = 3.0
	patrol_timer.start()

func _physics_process(_delta: float) -> void:
	if player and is_instance_valid(player):
		var distance = global_position.distance_to(player.global_position)
		if distance <= ATTACK_RANGE:
			_attack()
		else:
			_chase_player()
	elif exit_counter > 0:
		exit_counter -= 1
		if exit_counter == 0 and player == null:
			_start_patrol()
	elif not is_attacking:
		_patrol_movement()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("golem_damage"):
		player = body as CharacterBody2D
		activate = true
		exit_counter = 0

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		exit_counter = EXIT_THRESHOLD
		activate = false
		await get_tree().create_timer(0.5).timeout
		if exit_counter == 0:
			player = null
			_start_patrol()

func _attack() -> void:
	if is_attacking:
		return

	var rng = RandomNumberGenerator.new()
	var number = rng.randi_range(1, 3)
	is_attacking = true
	velocity = Vector2.ZERO  # Detiene el movimiento mientras ataca

	if number == 1:
		animation_player.play("attack_skeleton_animation")
	elif number == 2:
		animation_player.play("shield_skeleton_animation")
	elif number == 3:
		animation_player.play("attack_skeleton_animation")

	await animation_player.animation_finished
	is_attacking = false

	var restart_time = rng.randi_range(2, 3)
	attack_timer.wait_time = restart_time
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	if activate and not is_attacking:
		_attack()

func _start_patrol() -> void:
	patrol_timer.start()
	_patrol_movement()

func _patrol_movement() -> void:
	if not is_attacking and player == null:
		velocity.x = patrol_direction * PATROL_SPEED
		sprite.flip_h = patrol_direction < 0
		animation_player.play("walk_skeleton_animation")
		move_and_slide()

func _on_patrol_timer_timeout() -> void:
	patrol_direction *= -1
	_patrol_movement()

func _chase_player() -> void:
	if not is_attacking and player:
		var direction = player.global_position.x - global_position.x
		var move_direction = sign(direction)
		velocity.x = move_direction * CHASE_SPEED
		sprite.flip_h = move_direction < 0
		animation_player.play("walk_skeleton_animation")
		move_and_slide()


func _on_hurtbox_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("golem_damage"):
		$CanvasLayer/Vida.get_damage(15)
